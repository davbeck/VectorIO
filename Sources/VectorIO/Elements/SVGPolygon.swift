import Foundation
import CoreGraphics


public struct SVGPolygon: SVGElement {
	public static let elementName: String = "polygon"
	
	public var points: [CGPoint]
	public var style: CSSStyle
	
	public init(points: [CGPoint] = [], style: CSSStyle = CSSStyle()) {
		self.points = points
		self.style = style
	}
}
