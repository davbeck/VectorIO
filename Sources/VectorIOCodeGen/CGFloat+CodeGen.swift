import Foundation
import CoreGraphics


private let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    return formatter
}()

extension CGFloat {
    public func swiftDefinition() -> String {
        return formatter.string(from: NSNumber(value: Double(self))) ??
            String(Double(self))
    }
}
