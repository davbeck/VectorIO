import Foundation
import CoreGraphics


extension CGColor {
	public func swiftUIColorDefinition(alpha: CGFloat = 1) throws -> String {
		guard let colorSpace = self.colorSpace else { throw CodeGenError.invalidColor }
		let alpha = self.alpha * alpha
		let components = self.components ?? []
		
		switch colorSpace.model {
		case .rgb:
			return "UIColor(red: \(components[0].swiftDefinition()), green: \(components[1].swiftDefinition()), blue: \(components[2].swiftDefinition()), alpha: \(alpha.swiftDefinition()))"
		default:
			if #available(OSX 10.11, *) {
				guard
					let colorSpace = CGColorSpace(name: CGColorSpace.sRGB),
					let rgb = self.converted(to: colorSpace, intent: .defaultIntent, options: nil)
				else {
					throw CodeGenError.invalidColor
				}
				return try rgb.swiftUIColorDefinition(alpha: alpha)
			} else {
				throw CodeGenError.invalidColor
			}
		}
	}
}
