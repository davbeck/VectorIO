import Foundation
import VectorIO
import CoreGraphics


public enum CodeGenError: Swift.Error {
	case invalidTitle
	case invalidColor
}


public protocol UIDrawingCodeGenerator: SVGElement {
	func generateUIDrawingCode() throws -> String
	var shouldGenerate: Bool { get }
}

extension UIDrawingCodeGenerator {
	public var shouldGenerate: Bool {
		return style.hasFill || style.hasStroke
	}
}

extension CSSStyle {
	func generateUIDrawingCode() throws -> String {
		var code = ""
		if hasStroke {
			code += "path.lineWidth = \(strokeWidth ?? 1)\n"
		}
		
		code += """
		if let tintColor = tintColor {
			tintColor.set()
		} else {
		
		"""
		if hasFill, let fill = self.fill {
			let uiColor = try fill.swiftUIColorDefinition(alpha: fillOpacity ?? 1)
			code += "\t\(uiColor).setFill()\n"
		}
		if hasStroke, let stroke = self.stroke {
			let uiColor = try stroke.swiftUIColorDefinition(alpha: strokeOpacity ?? 1)
			code += "\t\(uiColor).setStroke()\n"
		}
		code += "}\n"
		
		if hasFill {
			code += "path.fill()\n"
		}
		
		if hasStroke {
			code += "path.stroke()\n"
		}
		
		return code
	}
}

extension SVGParentElement {
	public func generateUIDrawingCode() throws -> String {
		return try children
			.compactMap({ $0 as? UIDrawingCodeGenerator })
			.filter({ $0.shouldGenerate })
			.map({ try "do {\n\t\($0.generateUIDrawingCode())\n}" })
			.joined(separator: "\n")
	}
}

extension SVGGroup: UIDrawingCodeGenerator {
	public var shouldGenerate: Bool {
		return true
	}
}



extension SVG: UIDrawingCodeGenerator {
	public func generateUIImageExtension() throws -> String {
		guard !title.isEmpty else { throw CodeGenError.invalidTitle }
		let propertyTitle = title.lowerCamelCased()
		
		let childrenCode = try self.generateUIDrawingCode()
		
		
		return """
		import UIKit
		
		extension UIImage {
		    private static let \(propertyTitle)Cache = NSCache<AnyObject, UIImage>()
		
		    static func \(propertyTitle)(tintColor: UIColor? = nil) -> UIImage {
		        let key: AnyObject = tintColor ?? NSNull()
		        if let image = \(propertyTitle)Cache.object(forKey: key) {
		            return image
		        }
		
		        let renderer = UIGraphicsImageRenderer(size: \(size.swiftDefinition()))
		        let image = renderer.image { context in
		\(childrenCode.leftPad(count: 3))
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
		code += "let path = UIBezierPath(rect: \(frame.swiftDefinition()))\n"
		
		code += try style.generateUIDrawingCode()
		
		return code
	}
}

extension SVGEllipse: UIDrawingCodeGenerator {
	public func generateUIDrawingCode() throws -> String {
		var code = ""
		code += "let path = UIBezierPath(ovalIn: \(frame.swiftDefinition()))\n"
		
		code += try style.generateUIDrawingCode()
		
		return code
	}
}

extension SVGLine: UIDrawingCodeGenerator {
	public func generateUIDrawingCode() throws -> String {
		var code = ""
		code += "let path = UIBezierPath()\n"
		code += "path.move(to: \(start.swiftDefinition()))\n"
		code += "path.addLine(to: \(end.swiftDefinition()))\n"
		
		code += try style.generateUIDrawingCode()
		
		return code
	}
}

extension SVGPath: UIDrawingCodeGenerator {
	public func generateUIDrawingCode() throws -> String {
		var code = ""
		code += "let path = UIBezierPath()\n"
		for definition in definitions {
			switch definition {
			case .moveTo(let point):
				code += "path.move(to: \(point.swiftDefinition()))\n"
			case .lineTo(let point):
				code += "path.addLine(to: \(point.swiftDefinition()))\n"
			case .quadraticBezierCurve(let control, let end):
				code += "path.addQuadCurve(to: \(end.swiftDefinition()), controlPoint: \(control.swiftDefinition()))\n"
			case .cubicBezierCurve(let curve):
				code += "path.addCurve(to: \(curve.end.swiftDefinition()), controlPoint1: \(curve.controlStart.swiftDefinition()), controlPoint2: \(curve.controlEnd.swiftDefinition()))\n"
			case .closePath:
				code += "path.close()\n"
			}
		}
		
		code += try style.generateUIDrawingCode()
		
		return code
	}
}
