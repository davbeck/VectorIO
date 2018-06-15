import Foundation
import CoreGraphics


public struct CSSStyle {
    public enum Error: Swift.Error {
        case invalidRuleDefinition(String)
    }
    
    
    public enum Rule: Hashable {
		case fill(CGColor)
		case strokeWidth(CGFloat)
		case stroke(CGColor)
        case fillOpacity(CGFloat)
        case strokeOpacity(CGFloat)
        case opacity(CGFloat)
		
		public init?(ruleDefinition: String) throws {
			let parts = ruleDefinition.components(separatedBy: ":")
			guard parts.count == 2 else { throw Error.invalidRuleDefinition(ruleDefinition) }
			let name = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
			let value = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
			
			switch name.lowercased() {
			case "fill":
				self = try .fill(CGColor.parse(value))
			case "stroke-width":
				self = try .strokeWidth(CGFloat.parse(value))
			case "stroke":
				self = try .stroke(CGColor.parse(value))
            case "fill-opacity":
                self = try .fillOpacity(CGFloat.parse(value))
            case "stroke-opacity":
                self = try .strokeOpacity(CGFloat.parse(value))
            case "opacity":
                self = try .opacity(CGFloat.parse(value))
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
