import XCTest
import VectorIO
import VectorIOCodeGen


class UIBezierPathTestsTests: XCTestCase {
	// MARK - Helpers
	
	private func normalize(code: String) -> String {
		return code
			.components(separatedBy: .newlines)
			.map({ $0.trimmingCharacters(in: .whitespaces) })
			.filter({ !$0.isEmpty })
			.joined(separator: "\n")
	}
	
	
	// MARK - Tests
	
	func testRect() throws {
		var svg = SVG(size: CGSize(width: 400, height: 110), elements: [
			SVGRect(
				frame: CGRect(x: 0, y: 0, width: 300, height: 100),
				style: CSSStyle(
					fill: CGColor(red: 0, green: 0, blue: 1, alpha: 1),
					stroke: CGColor(red: 0, green: 0, blue: 0, alpha: 1),
					strokeWidth: 3
			))
			]
		)
		svg.title = "artboard"
		
		let code = try svg.generateUIImageCode()
		
		let expected = """
        import UIKit
        extension UIImage {
            private static let artboardCache = NSCache<AnyObject, UIImage>()
            private static let artboardRenderer = UIGraphicsImageRenderer(size: CGSize(width: 400, height: 110))
            static func artboard(tintColor: UIColor? = nil) -> UIImage {
                let key: AnyObject = tintColor ?? NSNull()
                if let image = artboardCache.object(forKey: key) {
                    return image
                }
                let image = artboardRenderer.image { context in
                    do {
                        let path = UIBezierPath(rect: CGRect(x: 0.00, y: 0.00, width: 300.00, height: 100.00))
                        path.lineWidth = 3.0
                        (tintColor ?? UIColor(red: 0.00, green: 0.00, blue: 1.00, alpha: 1.00)).setFill()
                        path.fill()
                        (tintColor ?? UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00)).setStroke()
                        path.stroke()
                    }
                }
                artboardCache.setObject(image, forKey: key)
                return image
            }
        }
        """
		
		XCTAssertEqual(normalize(code: code), normalize(code: expected))
		
		
		try code.write(toFile: "/Users/davidbeck/Desktop/code.swift", atomically: true, encoding: .utf8)
		try expected.write(toFile: "/Users/davidbeck/Desktop/expected.swift", atomically: true, encoding: .utf8)
	}
}
