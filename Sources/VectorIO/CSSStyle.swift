import Foundation
import CoreGraphics


public struct CSSStyle: Hashable {
    public enum Error: Swift.Error {
        case invalidRuleDefinition(String)
    }
    
	
	var fill: CGColor?
	var fillOpacity: CGFloat?
	var stroke: CGColor?
	var strokeWidth: CGFloat?
	var strokeOpacity: CGFloat?
	var opacity: CGFloat?
	
	
	public init(
		fill: CGColor? = nil,
		fillOpacity: CGFloat? = nil,
		stroke: CGColor? = nil,
		strokeWidth: CGFloat? = nil,
		strokeOpacity: CGFloat? = nil,
		opacity: CGFloat? = nil
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
	
	public func merging(_ other: CSSStyle) -> CSSStyle {
		var new = self
		new.merge(other)
		return new
	}
	
	public mutating func merge(_ other: CSSStyle) {
		if let fill = other.fill {
			self.fill = fill
		}
		if let fillOpacity = other.fillOpacity {
			self.fillOpacity = fillOpacity
		}
		if let stroke = other.stroke {
			self.stroke = stroke
		}
		if let strokeWidth = other.strokeWidth {
			self.strokeWidth = strokeWidth
		}
		if let strokeOpacity = other.strokeOpacity {
			self.strokeOpacity = strokeOpacity
		}
		if let opacity = other.opacity {
			self.opacity = opacity
		}
	}
}
