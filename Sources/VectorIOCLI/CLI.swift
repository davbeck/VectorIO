import Foundation
import VectorIO
import VectorIOCodeGen


public class CLI {
	public let arguments: [String]
	
	public init(arguments: [String] = CommandLine.arguments) {
		self.arguments = Array(arguments.dropFirst())
	}
	
	public func run() {
		do {
			let inputs = arguments.map({ URL(fileURLWithPath: $0) })
			
			for input in inputs {
				let name = input.deletingPathExtension().lastPathComponent
				
				guard let parser = SVGParser(contentsOf: input) else { continue }
				let svg = try parser.parse()
				
				let output = input.deletingLastPathComponent().appendingPathComponent("\(name)+UIImage.swift")
				
				
				try svg.generateUIImageExtension().write(to: output, atomically: true, encoding: .utf8)
			}
		} catch {
			print("failed to convert files: \(error)")
		}
	}
}
