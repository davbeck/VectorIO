import Foundation
import CoreGraphics


public struct SVGPolyline: SVGElement {
	public static let elementName: String = "polyline"
	
	public var points: [CGPoint]
	public var style: CSSStyle
	
	public init(points: [CGPoint] = [], style: CSSStyle = CSSStyle()) {
		self.points = points
		self.style = style
	}
}
