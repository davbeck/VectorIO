import Foundation
import VectorIO


extension Collection where Index == Int {
	func asyncForEach(_ body: @escaping (Self.Element) throws -> Void) throws {
		let collection = self
		let thrownLock = NSLock()
		var thrown: Error?
		DispatchQueue.concurrentPerform(iterations: collection.count) { index in
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
	
	public func run() throws {
		let inputs = arguments.map({ URL(fileURLWithPath: $0) })
		
		try inputs.asyncForEach { input in
			try self.process(input: input)
		}
	}
	
	private func process(input: URL) throws {
		if let subInputs = try? FileManager.default.contentsOfDirectory(at: input, includingPropertiesForKeys: nil, options: []) {
			try subInputs.asyncForEach({ input in
				guard input.pathExtension.lowercased() == "svg" else { return }
				try self.process(input: input)
			})
		} else {
			let outputName = input.deletingPathExtension().lastPathComponent
			let output = input
				.deletingLastPathComponent()
				.appendingPathComponent("\(outputName)+UIImage.swift")
			
			let inputModificationDate = (try? FileManager.default.attributesOfItem(atPath: input.path)[.modificationDate]) as? Date
			let ouptutModificationDate = (try? FileManager.default.attributesOfItem(atPath: output.path)[.modificationDate]) as? Date
			
			if let ouptutModificationDate = ouptutModificationDate, let inputModificationDate = inputModificationDate, inputModificationDate < ouptutModificationDate {
				return
			}
			
			guard let parser = SVGParser(contentsOf: input) else { return }
			let svg = try parser.parse()
			
			try svg.generateUIImageExtension().write(to: output, atomically: true, encoding: .utf8)
		}
	}
}
