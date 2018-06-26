import Foundation
import CoreGraphics


public struct CubicBezierCurve: Equatable {
	public var controlStart: CGPoint
	public var controlEnd: CGPoint
	public var end: CGPoint
	
	public init(controlStart: CGPoint, controlEnd: CGPoint, end: CGPoint) {
		self.controlStart = controlStart
		self.controlEnd = controlEnd
		self.end = end
	}
}


public struct SVGPath: SVGElement {
	public static let elementName: String = "path"
	
	public enum Definition: Equatable {
		case moveTo(CGPoint)
		case lineTo(CGPoint)
		case quadraticBezierCurve(control: CGPoint, end: CGPoint)
		case cubicBezierCurve(CubicBezierCurve)
		case closePath
		
		public static func cubicBezierCurve(controlStart: CGPoint, controlEnd: CGPoint, end: CGPoint) -> Definition {
			return .cubicBezierCurve(CubicBezierCurve(controlStart: controlStart, controlEnd: controlEnd, end: end))
		}
	}
	
	public var definitions: [Definition]
	public var style: CSSStyle
	
	public init(definitions: [Definition] = [], style: CSSStyle = CSSStyle()) {
		self.definitions = definitions
		self.style = style
	}
}
