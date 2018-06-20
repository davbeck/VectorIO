import Foundation


func normalize(code: String) -> String {
	return code
		.components(separatedBy: .newlines)
		.map({ $0.trimmingCharacters(in: .whitespaces) })
		.filter({ !$0.isEmpty })
		.joined(separator: "\n")
}
