import XCTest
import VectorIO
import VectorIOCodeGen


class UIBezierPathTestsTests: XCTestCase {
	func testUIImageExtension() throws {
		var svg = SVG(
			size: CGSize(width: 400, height: 110),
			elements: [
				SVGRect(
					frame: CGRect(x: 0, y: 0, width: 300, height: 100),
					style: CSSStyle(
						fill: CGColor(red: 0, green: 0, blue: 1, alpha: 1),
						stroke: CGColor(red: 0, green: 0, blue: 0, alpha: 1),
						strokeWidth: 3
					)
				),
			]
		)
		svg.title = "artboard"
		
		let code = try svg.generateUIImageExtension()
		
		let expected = """
		import UIKit
		extension UIImage {
			private static let artboardCache = NSCache<AnyObject, UIImage>()
			static func artboard(tintColor: UIColor? = nil) -> UIImage {
				let key: AnyObject = tintColor ?? NSNull()
				if let image = artboardCache.object(forKey: key) {
					return image
				}
				let renderer = UIGraphicsImageRenderer(size: CGSize(width: 400.00, height: 110.00))
				let image = renderer.image { context in
					do {
						let path = UIBezierPath(rect: CGRect(x: 0.00, y: 0.00, width: 300.00, height: 100.00))
						path.lineWidth = 3.0
						if let tintColor = tintColor {
							tintColor.set()
						} else {
							UIColor(red: 0.00, green: 0.00, blue: 1.00, alpha: 1.00).setFill()
							UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00).setStroke()
						}
						path.fill()
						path.stroke()
					}
				}
				artboardCache.setObject(image, forKey: key)
				return image
			}
		}
		"""
		
		XCTAssertEqual(normalize(code: code), normalize(code: expected))
	}
	
	func testCircle() throws {
		let element = SVGEllipse(center: CGPoint(x: 50, y: 50), radius: CGSize(width: 30, height: 20), style: CSSStyle(
			fill: CGColor(red: 0, green: 0, blue: 1, alpha: 1),
			stroke: CGColor(red: 0, green: 0, blue: 0, alpha: 1),
			strokeWidth: 3
		))
		
		let code = try element.generateUIDrawingCode()
		
		let expected = """
		let path = UIBezierPath(ovalIn: CGRect(x: 20.00, y: 30.00, width: 60.00, height: 40.00))
		path.lineWidth = 3.0
		if let tintColor = tintColor {
			tintColor.set()
		} else {
			UIColor(red: 0.00, green: 0.00, blue: 1.00, alpha: 1.00).setFill()
			UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00).setStroke()
		}
		path.fill()
		path.stroke()
		"""
		
		XCTAssertEqual(normalize(code: code), normalize(code: expected))
	}
	
	func testPath() throws {
		let element = SVGPath(definitions: [
			SVGPath.Definition.moveTo(CGPoint(x: 10, y: 90)),
			SVGPath.Definition.cubicBezierCurve(controlStart: CGPoint(x: 30, y: 90), controlEnd: CGPoint(x: 30, y: 10), end: CGPoint(x: 50, y: 10)),
			SVGPath.Definition.cubicBezierCurve(controlStart: CGPoint(x: 70, y: 10), controlEnd: CGPoint(x: 70, y: 90), end: CGPoint(x: 90, y: 90)),
		], style: CSSStyle(
			fill: CGColor(red: 0, green: 0, blue: 1, alpha: 1),
			stroke: CGColor(red: 0, green: 0, blue: 0, alpha: 1),
			strokeWidth: 3
		))
		
		let code = try element.generateUIDrawingCode()
		
		let expected = """
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 10.00, y: 90.00))
		path.addCurve(to: CGPoint(x: 50.00, y: 10.00), controlPoint1: CGPoint(x: 30.00, y: 90.00), controlPoint2: CGPoint(x: 30.00, y: 10.00))
		path.addCurve(to: CGPoint(x: 90.00, y: 90.00), controlPoint1: CGPoint(x: 70.00, y: 10.00), controlPoint2: CGPoint(x: 70.00, y: 90.00))
		path.lineWidth = 3.0
		if let tintColor = tintColor {
			tintColor.set()
		} else {
			UIColor(red: 0.00, green: 0.00, blue: 1.00, alpha: 1.00).setFill()
			UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00).setStroke()
		}
		path.fill()
		path.stroke()
		"""
		
		XCTAssertEqual(normalize(code: code), normalize(code: expected))
	}
}
