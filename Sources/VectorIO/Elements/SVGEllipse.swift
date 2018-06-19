import Foundation
import CoreGraphics


public struct SVGEllipse: SVGElement {
	public static let elementName: String = "ellipse"
	
	public var center: CGPoint
	public var radius: CGSize
	public var style: CSSStyle
	
	public var frame: CGRect {
		return CGRect(x: center.x - radius.width, y: center.y - radius.height, width: radius.width * 2, height: radius.height * 2)
	}
	
	public init(center: CGPoint = .zero, radius: CGSize = .zero, style: CSSStyle = CSSStyle()) {
		self.center = center
		self.radius = radius
		self.style = style
	}
}
