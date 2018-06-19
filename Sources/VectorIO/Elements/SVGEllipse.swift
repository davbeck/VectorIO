import Foundation
import CoreGraphics


public struct SVGEllipse: SVGElement {
	public static let elementName: String = "ellipse"
	
	public var center: CGPoint
	public var radius: CGSize
	public var style: CSSStyle
	
	public init(center: CGPoint = .zero, radius: CGSize = .zero, style: CSSStyle = CSSStyle()) {
		self.center = center
		self.radius = radius
		self.style = style
	}
}
