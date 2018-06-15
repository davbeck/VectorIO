import CoreGraphics


public struct SVG {
	public var size: CGSize
	public var elements: Array<SVGElement>
	
	public init(size: CGSize = .zero, elements: Array<SVGElement> = []) {
		self.size = size
		self.elements = elements
	}
}
