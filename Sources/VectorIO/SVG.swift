import CoreGraphics


public struct SVG {
	public var size: CGSize
	public var viewBox: CGRect
	public var elements: Array<SVGElement>
	
	public init(size: CGSize = .zero, viewBox: CGRect = .zero, elements: Array<SVGElement> = []) {
		self.size = size
		self.elements = elements
		self.viewBox = viewBox
	}
}
