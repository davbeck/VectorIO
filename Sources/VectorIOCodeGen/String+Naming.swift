import Foundation


extension String {
	private func gsub(pattern: String, with template: String) -> String {
		do {
			let range = NSRange(startIndex..<endIndex, in: self)
			let expression = try NSRegularExpression(pattern: pattern)
			return expression.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: template)
		} catch {
			return self
		}
	}
	
	private func rawSnakeCased() -> String {
		return self
			.replacingOccurrences(of: " ", with: "_")
			.gsub(pattern: "([A-Z]+)([A-Z][a-z])", with: "$1_$2")
			.gsub(pattern: "([a-z\\d])([A-Z])", with: "$1_$2")
			.replacingOccurrences(of: "-", with: "_")
	}
	
	private func nameComponents() -> Array<String> {
		return rawSnakeCased().components(separatedBy: "_")
	}
	
	public func lowerCamelCased() -> String {
		let nameComponents = self.nameComponents()
		guard let first = nameComponents.first?.lowercased() else { return "" }
		let trailingCompontents = nameComponents.dropFirst().map({ $0.capitalized })
		let components = [first] + trailingCompontents
		return components.joined()
	}
}
