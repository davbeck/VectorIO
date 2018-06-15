import Foundation
import CoreGraphics


public enum SVGStyleParseError: Swift.Error {
	case invalidRuleDefinition(String)
}


public struct SVGStyle {
	public enum Rule: Equatable {
		case fill(CGColor)
		case strokeWidth(CGFloat)
		case stroke(CGColor)
		
		public init?(ruleDefinition: String) throws {
			let parts = ruleDefinition.components(separatedBy: ":")
			guard parts.count == 2 else { throw SVGStyleParseError.invalidRuleDefinition(ruleDefinition) }
			let name = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
			let value = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
			
			switch name.lowercased() {
			case "fill":
				self = try .fill(CGColor.parse(value))
			case "stroke-width":
				self = try .strokeWidth(CGFloat.parse(value))
			case "stroke":
				self = try .stroke(CGColor.parse(value))
			default:
				print("unrecognized style rule \(ruleDefinition)")
				return nil
			}
		}
	}
	
	public var rules: Array<Rule>
	
	
	public init(rules: Array<Rule> = []) {
		self.rules = rules
	}
	
	public init(definition: String) throws {
		self.rules = try definition
			.components(separatedBy: ";")
			.compactMap({ try Rule(ruleDefinition: $0) })
	}
}
