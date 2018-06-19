import CoreGraphics


public struct SVG: SVGParentElement {
	public static let elementName: String = "svg"
	
	public var size: CGSize
	public var viewBox: CGRect
	public var children: Array<SVGElement>
	public var style: CSSStyle
	
	public init(size: CGSize = .zero, viewBox: CGRect = .zero, elements: Array<SVGElement> = [], style: CSSStyle = CSSStyle()) {
		self.size = size
		self.viewBox = viewBox
		self.children = elements
		self.style = style
	}
}
