import Foundation
import CoreGraphics


public struct SVGElement {
	public var path: CGPath
	public var style: SVGStyle
	
	public init(path: CGPath, style: SVGStyle = SVGStyle()) {
		self.path = path
		self.style = style
	}
}
