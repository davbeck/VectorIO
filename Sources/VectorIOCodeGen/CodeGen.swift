import Foundation
import VectorIO
import CoreGraphics


public enum CodeGenError: Swift.Error {
    case invalidTitle
	case invalidColor
}


public protocol UIDrawingCodeGenerator: SVGElement {
    func generateUIDrawingCode() throws -> String
}

extension SVG {
    public func generateUIImageCode() throws -> String {
        guard !title.isEmpty else { throw CodeGenError.invalidTitle }
        let propertyTitle = title.lowerCamelCased()
        
        let childrenCode = try children
            .compactMap({ $0 as? UIDrawingCodeGenerator })
            .map({ try $0.generateUIDrawingCode() })
            .joined(separator: "\n")
            .leftPad(count: 3)
            
        
        return """
        import UIKit
        
        extension UIImage {
            private static let \(propertyTitle)Cache = NSCache<AnyObject, UIImage>()
            private static let \(propertyTitle)Renderer = UIGraphicsImageRenderer(size: CGSize(width: 400, height: 110))
        
            static func \(propertyTitle)(tintColor: UIColor? = nil) -> UIImage {
                let key: AnyObject = tintColor ?? NSNull()
                if let image = \(propertyTitle)Cache.object(forKey: key) {
                    return image
                }
        
                let image = \(propertyTitle)Renderer.image { context in
        \(childrenCode)
                }
                \(propertyTitle)Cache.setObject(image, forKey: key)
                
                return image
            }
        }
        """
    }
}

extension SVGRect: UIDrawingCodeGenerator {
    public func generateUIDrawingCode() throws -> String {
		var code = ""
		code += "do {\n"
		code += "\tlet path = UIBezierPath(rect: \(frame.swiftDefinition()))\n"
		
		if let strokeWidth = style.strokeWidth {
			code += "\tpath.lineWidth = \(strokeWidth)\n"
		}
		
		if let fill = style.fill, fill != .clear {
			let uiColor = try fill.swiftUIColorDefinition(alpha: style.strokeOpacity ?? 1)
			
			code += "\t(tintColor ?? \(uiColor)).setFill()\n"
			code += "\tpath.fill()\n"
		}
		
		if let strokeWidth = style.strokeWidth, strokeWidth > 0, let stroke = style.stroke {
			let uiColor = try stroke.swiftUIColorDefinition(alpha: style.strokeOpacity ?? 1)
			
			code += "\t(tintColor ?? \(uiColor)).setStroke()\n"
			code += "\tpath.stroke()\n"
		}
		code += "}"
		
		return code
    }
}
