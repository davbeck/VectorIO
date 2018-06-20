import Foundation
import VectorIO


extension Collection where Index == Int {
	func asyncForEach(_ body: @escaping (Self.Element) throws -> Void) throws {
		let collection = self
		let thrownLock = NSLock()
		var thrown: Error?
		DispatchQueue.concurrentPerform(iterations: collection.count) { (index) in
			let input = collection[index]
			
			do {
				try body(input)
			} catch {
				thrownLock.lock()
				thrown = error
				thrownLock.unlock()
			}
		}
		
		if let error = thrown {
			throw error
		}
	}
}


public class CLI {
	public let arguments: [String]
	
	public init(arguments: [String] = Array(CommandLine.arguments.dropFirst())) {
		self.arguments = arguments
	}
	
	public func run() {
		do {
			let inputs = arguments.map({ URL(fileURLWithPath: $0) })
			
			try inputs.asyncForEach { (input) in
				try self.process(input: input)
			}
		} catch {
			print("failed to convert files: \(error)")
		}
	}
	
	private func process(input: URL) throws {
		if let subInputs = try? FileManager.default.contentsOfDirectory(at: input, includingPropertiesForKeys: nil, options: []) {
			try subInputs.asyncForEach({ (input) in
				try self.process(input: input)
			})
		} else {
			guard let parser = SVGParser(contentsOf: input) else { return }
			let svg = try parser.parse()
			
			let output = input.deletingLastPathComponent().appendingPathComponent("\(svg.title)+UIImage.swift")
			
			try svg.generateUIImageExtension().write(to: output, atomically: true, encoding: .utf8)
		}
	}
}
