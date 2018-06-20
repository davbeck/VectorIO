import Foundation
import VectorIO
import VectorIOCodeGen


public class CLI {
	public let arguments: [String]
	
	public init(arguments: [String] = Array(CommandLine.arguments.dropFirst())) {
		self.arguments = arguments
	}
	
	public func run() {
		do {
			let inputs = arguments.map({ URL(fileURLWithPath: $0) })
			
			for input in inputs {
				if let subInputs = try? FileManager.default.contentsOfDirectory(at: input, includingPropertiesForKeys: nil, options: []) {
					for input in subInputs {
						try process(input: input)
					}
				} else {
					try process(input: input)
				}
			}
		} catch {
			print("failed to convert files: \(error)")
		}
	}
	
	private func process(input: URL) throws {
		guard let parser = SVGParser(contentsOf: input) else { return }
		let svg = try parser.parse()
		
		let output = input.deletingLastPathComponent().appendingPathComponent("\(svg.title)+UIImage.swift")
		
		try svg.generateUIImageExtension().write(to: output, atomically: true, encoding: .utf8)
	}
}
