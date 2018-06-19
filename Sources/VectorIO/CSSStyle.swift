import Foundation
import CoreGraphics


public struct CSSStyle: Hashable {
    public enum Error: Swift.Error {
        case invalidRuleDefinition(String)
    }
    
	
	public var fill: CGColor?
	public var fillOpacity: CGFloat?
	public var stroke: CGColor?
	public var strokeWidth: CGFloat?
	public var strokeOpacity: CGFloat?
	public var opacity: CGFloat?
	public var fillRule: FillRule?
	
	public var hasStroke: Bool {
		guard let stroke = self.stroke else { return false }
		return stroke != .clear && (strokeWidth ?? 1) > 0
	}
	
	public var hasFill: Bool {
		guard let fill = self.fill else { return false }
		return fill != .clear
	}
	
	
	public init(
		fill: CGColor? = nil,
		fillOpacity: CGFloat? = nil,
		stroke: CGColor? = nil,
		strokeWidth: CGFloat? = nil,
		strokeOpacity: CGFloat? = nil,
		opacity: CGFloat? = nil,
		fillRule: FillRule? = nil
	) {
		self.fill = fill
		self.fillOpacity = fillOpacity
		self.stroke = stroke
		self.strokeWidth = strokeWidth
		self.strokeOpacity = strokeOpacity
		self.opacity = opacity
		self.fillRule = fillRule
	}
	
	public init(definition: String) throws {
		let ruleDefinitions = definition
			.components(separatedBy: ";")
		
		for ruleDefinition in ruleDefinitions {
			guard !ruleDefinition.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { continue }
			let parts = ruleDefinition.components(separatedBy: ":")
			guard parts.count == 2 else {
				throw Error.invalidRuleDefinition(ruleDefinition)
			}
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
			case "fill-rule":
				self.fillRule = FillRule(rawValue: value)
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
		if let fillRule = other.fillRule {
			self.fillRule = fillRule
		}
	}
}
