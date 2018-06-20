import Foundation
import CoreGraphics


extension CGSize {
	public func swiftDefinition() -> String {
		return "CGSize(width: \(width.swiftDefinition()), height: \(height.swiftDefinition()))"
	}
}
