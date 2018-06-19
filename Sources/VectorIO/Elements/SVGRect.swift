import Foundation
import CoreGraphics


public struct SVGRect: SVGElement {
	public static let elementName: String = "rect"
	
	public var frame: CGRect
	public var radiusX: CGFloat
	public var radiusY: CGFloat
	public var style: CSSStyle
	
	public var title: String = ""
	
	public init(frame: CGRect = .zero, radiusX: CGFloat = 0, radiusY: CGFloat = 0, style: CSSStyle = CSSStyle()) {
		self.frame = frame
		self.radiusX = radiusX
		self.radiusY = radiusY
		self.style = style
	}
}
