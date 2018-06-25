import Foundation


extension String {
	func replacingOccurrences(of expression: NSRegularExpression, with template: String) -> String {
		let range = NSRange(startIndex..<endIndex, in: self)
		return expression.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: template)
	}
	
	func replacingOccurrence(of expression: NSRegularExpression, with template: ([Substring]) -> String) -> String {
		guard
			let result = expression.firstMatch(in: self, options: [], range: NSRange(startIndex..<endIndex, in: self)),
			let range = Range(result.range, in: self)
			else { return self }
		
		let matches = (0..<result.numberOfRanges)
			.compactMap({ Range(result.range(at: $0), in: self) })
			.map({ self[$0] })
		return self.replacingCharacters(in: range, with: template(matches))
	}
	
	func replacingOccurrences(of expression: NSRegularExpression, with template: ([Substring]) -> String) -> String {
		let result = self.replacingOccurrence(of: expression, with: template)
		
		if result != self {
			return result.replacingOccurrences(of: expression, with: template)
		} else {
			return result
		}
	}
}


extension NSRegularExpression {
	func matches(in string: String, options: NSRegularExpression.MatchingOptions = []) -> Array<NSTextCheckingResult> {
		var results = Array<NSTextCheckingResult>()
		
		self.enumerateMatches(in: string, options: options, range: NSRange(string.startIndex..<string.endIndex, in: string)) { (result, flags, stop) in
			guard let result = result else { return }
			
			results.append(result)
		}
		
		return results
	}
}
