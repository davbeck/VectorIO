import CoreGraphics


public struct SVG: SVGParentElement {
	public static let elementName: String = "svg"
	
	public var size: CGSize
	public var viewBox: CGRect
	public var children: Array<SVGElement>
	public var style: CSSStyle
    
    public var title: String = ""
    
    public init(elements: Array<SVGElement> = [], style: CSSStyle = CSSStyle()) {
        self.init(size: .zero, viewBox: .zero, elements: elements, style: style)
    }
    
    public init(size: CGSize, elements: Array<SVGElement> = [], style: CSSStyle = CSSStyle()) {
        self.init(size: size, viewBox: CGRect(origin: .zero, size: size), elements: elements, style: style)
    }
        
    public init(viewBox: CGRect = .zero, elements: Array<SVGElement> = [], style: CSSStyle = CSSStyle()) {
        self.init(size: viewBox.size, viewBox: viewBox, elements: elements, style: style)
    }
            
    public init(size: CGSize, viewBox: CGRect, elements: Array<SVGElement> = [], style: CSSStyle = CSSStyle()) {
		self.size = size
		self.viewBox = viewBox
		self.children = elements
		self.style = style
	}
}
