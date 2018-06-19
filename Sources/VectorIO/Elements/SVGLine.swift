import Foundation
import CoreGraphics


public struct SVGLine: SVGElement {
	public static let elementName: String = "ellipse"
	
	public var start: CGPoint
	public var end: CGPoint
	public var style: CSSStyle
	
	public init(start: CGPoint = .zero, end: CGPoint = .zero, style: CSSStyle = CSSStyle()) {
		self.start = start
		self.end = end
		self.style = style
	}
}
