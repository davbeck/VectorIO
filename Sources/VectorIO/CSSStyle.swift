import Foundation
import CoreGraphics


public struct CSSStyle: Hashable {
    public enum Error: Swift.Error {
        case invalidRuleDefinition(String)
    }
    
	
	var fill: CGColor? = nil
	var fillOpacity: CGFloat = 1
	var stroke: CGColor? = nil
	var strokeWidth: CGFloat = 0
	var strokeOpacity: CGFloat = 1
	var opacity: CGFloat = 1
	
	
	public init(
		fill: CGColor? = nil,
		fillOpacity: CGFloat = 1,
		stroke: CGColor? = nil,
		strokeWidth: CGFloat = 0,
		strokeOpacity: CGFloat = 1,
		opacity: CGFloat = 1
	) {
		self.fill = fill
		self.fillOpacity = fillOpacity
		self.stroke = stroke
		self.strokeWidth = strokeWidth
		self.strokeOpacity = strokeOpacity
		self.opacity = opacity
	}
	
	public init(definition: String) throws {
		let ruleDefinitions = definition
			.components(separatedBy: ";")
		
		for ruleDefinition in ruleDefinitions {
			let parts = ruleDefinition.components(separatedBy: ":")
			guard parts.count == 2 else { throw Error.invalidRuleDefinition(ruleDefinition) }
			let name = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
			let value = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
			
			switch name.lowercased() {
			case "fill":
				self.fill = try CGColor.parse(value)
			case "stroke-width":
				self.strokeWidth = try CGFloat.parse(value)
			case "stroke":
				self.stroke = try CGColor.parse(value)
			case "fill-opacity":
				self.fillOpacity = try CGFloat.parse(value)
			case "stroke-opacity":
				self.strokeOpacity = try CGFloat.parse(value)
			case "opacity":
				self.opacity = try CGFloat.parse(value)
			default:
				print("unrecognized style rule \(ruleDefinition)")
			}
		}
	}
}
