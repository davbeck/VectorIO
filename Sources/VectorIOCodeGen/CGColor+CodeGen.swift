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
		case .unknown:
			throw CodeGenError.invalidColor
		case .monochrome:
			throw CodeGenError.invalidColor
		case .cmyk:
			throw CodeGenError.invalidColor
		case .lab:
			throw CodeGenError.invalidColor
		case .deviceN:
			throw CodeGenError.invalidColor
		case .indexed:
			throw CodeGenError.invalidColor
		case .pattern:
			throw CodeGenError.invalidColor
		}
	}
}
