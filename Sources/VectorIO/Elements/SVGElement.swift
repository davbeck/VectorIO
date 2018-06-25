import Foundation
import CoreGraphics


public protocol SVGElement {
	static var elementName: String { get }
	var style: CSSStyle { get set }
}

public protocol SVGParentElement: SVGElement {
	var children: Array<SVGElement> { get set }
	mutating func append(_ child: SVGElement)
}

extension SVGParentElement {
	public mutating func append(_ child: SVGElement) {
		var child = child
		let style = child.style
		child.style = CSSStyle.defaults.merging(self.style).merging(style)
		children.append(child)
	}
}
