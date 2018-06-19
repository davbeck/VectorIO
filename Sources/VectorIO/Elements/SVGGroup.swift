import Foundation
import CoreGraphics


public struct SVGGroup: SVGParentElement {
	public static let elementName: String = "g"
	
	public var style: CSSStyle
	public var children: Array<SVGElement>
	
	public init(elements: Array<SVGElement> = [], style: CSSStyle = CSSStyle()) {
		self.children = elements
		self.style = style
	}
}
