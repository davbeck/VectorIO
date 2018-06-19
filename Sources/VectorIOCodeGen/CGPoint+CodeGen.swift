import Foundation
import CoreGraphics


extension CGPoint {
	public func swiftDefinition() -> String {
		return "CGPoint(x: \(x.swiftDefinition()), y: \(y.swiftDefinition()))"
	}
}
