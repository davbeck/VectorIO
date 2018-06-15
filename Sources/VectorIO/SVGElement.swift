import Foundation
import CoreGraphics


public protocol SVGElement {
    static var elementName: String { get }
    var style: CSSStyle { get set }
}

public struct SVGRect: SVGElement {
    public static let elementName: String = "rect"
    
    public var frame: CGRect
    public var radiusX: CGFloat
    public var radiusY: CGFloat
    public var style: CSSStyle
    
    public init(frame: CGRect = .zero, radiusX: CGFloat = 0, radiusY: CGFloat = 0, style: CSSStyle = CSSStyle()) {
        self.frame = frame
        self.radiusX = radiusX
        self.radiusY = radiusY
        self.style = style
    }
}

public struct SVGCircle: SVGElement {
	public static let elementName: String = "circle"
	
	public var center: CGPoint
	public var radius: CGFloat
	public var style: CSSStyle
	
	public init(center: CGPoint = .zero, radius: CGFloat = 0, style: CSSStyle = CSSStyle()) {
		self.center = center
		self.radius = radius
		self.style = style
	}
}

public struct SVGEllipse: SVGElement {
	public static let elementName: String = "ellipse"
	
	public var center: CGPoint
	public var radius: CGSize
	public var style: CSSStyle
	
	public init(center: CGPoint = .zero, radius: CGSize = .zero, style: CSSStyle = CSSStyle()) {
		self.center = center
		self.radius = radius
		self.style = style
	}
}
