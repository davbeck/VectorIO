import Foundation
import CoreGraphics


extension CGRect {
    public func swiftDefinition() -> String {
        return "CGRect(x: \(origin.x.swiftDefinition()), y: \(origin.y.swiftDefinition()), width: \(width.swiftDefinition()), height: \(height.swiftDefinition()))"
    }
}
