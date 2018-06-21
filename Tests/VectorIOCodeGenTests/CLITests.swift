import XCTest
import VectorIO
import VectorIOCodeGen


class CLITests: XCTestCase {
	var directory: URL!
	var heartSVG: String!
	var heartURL: URL!
	var heartOutputURL: URL!
	var tagSVG: String!
	var tagURL: URL!
	var tagOutputURL: URL!
	
	override func setUp() {
		super.setUp()
		
		directory = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("CLITests")
		try? FileManager.default.removeItem(at: directory)
		try! FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
		
		heartURL = directory.appendingPathComponent("Heart.svg")
		heartOutputURL = directory.appendingPathComponent("Heart+UIImage.swift")
		heartSVG = """
		<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
			<path fill="none" stroke="red"
			d="M 10,30
			A 20,20 0,0,1 50,30
			A 20,20 0,0,1 90,30
			Q 90,60 50,90
			Q 10,60 10,30 z" />
		</svg>
		"""
		try! heartSVG.write(to: heartURL, atomically: true, encoding: .utf8)
		
		tagURL = directory.appendingPathComponent("Tag.svg")
		tagOutputURL = directory.appendingPathComponent("NoteTag+UIImage.swift")
		tagSVG = """
		<?xml version="1.0" encoding="UTF-8"?>
		<svg width="14px" height="14px" viewBox="0 0 14 14" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
			<!-- Generator: Sketch 50.2 (55047) - http://www.bohemiancoding.com/sketch -->
			<title>NoteTag</title>
			<desc>Created with Sketch.</desc>
			<defs></defs>
			<g id="tag" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
				<path d="M6.22780584,1.22780584 L12.9500281,7.95002806 C13.2537692,8.25376917 13.2537692,8.74623083 12.9500281,9.04997194 L9.04997194,12.9500281 C8.74623083,13.2537692 8.25376917,13.2537692 7.95002806,12.9500281 L1.22780584,6.22780584 C1.08194421,6.08194421 1,5.88411339 1,5.6778339 L1,1.77777778 C1,1.34822297 1.34822297,1 1.77777778,1 L5.6778339,1 C5.88411339,1 6.08194421,1.08194421 6.22780584,1.22780584 Z M3.5,4.66666667 C4.14433221,4.66666667 4.66666667,4.14433221 4.66666667,3.5 C4.66666667,2.85566779 4.14433221,2.33333333 3.5,2.33333333 C2.85566779,2.33333333 2.33333333,2.85566779 2.33333333,3.5 C2.33333333,4.14433221 2.85566779,4.66666667 3.5,4.66666667 Z" id="Combined-Shape" fill="#777777"></path>
			</g>
		</svg>
		"""
		try! tagSVG.write(to: tagURL, atomically: true, encoding: .utf8)
	}
	
	override func tearDown() {
		directory = nil
		heartURL = nil
		tagURL = nil
		
		super.tearDown()
	}
	
	
	// MARK: - Tests
	
	func testIndividualFiles() throws {
		let cli = CLI(arguments: [heartURL.path, tagURL.path])
		try cli.run()
		
		do {
			let output = try String(contentsOf: heartOutputURL)
			var parsed = try SVGParser(data: heartSVG.data(using: .utf8)!).parse()
			parsed.title = "Heart"
			let expected = try parsed.generateUIImageExtension()
			XCTAssertEqual(normalize(code: output), normalize(code: expected))
		}
		
		do {
			let output = try String(contentsOf: tagOutputURL)
			let parsed = try SVGParser(data: tagSVG.data(using: .utf8)!).parse()
			let expected = try parsed.generateUIImageExtension()
			XCTAssertEqual(normalize(code: output), normalize(code: expected))
		}
	}
	
	func testFolder() throws {
		let cli = CLI(arguments: [directory.path])
		try cli.run()
		
		do {
			let output = try String(contentsOf: heartOutputURL)
			var parsed = try SVGParser(data: heartSVG.data(using: .utf8)!).parse()
			parsed.title = "Heart"
			let expected = try parsed.generateUIImageExtension()
			XCTAssertEqual(normalize(code: output), normalize(code: expected))
		}
		
		do {
			let output = try String(contentsOf: tagOutputURL)
			let parsed = try SVGParser(data: tagSVG.data(using: .utf8)!).parse()
			let expected = try parsed.generateUIImageExtension()
			XCTAssertEqual(normalize(code: output), normalize(code: expected))
		}
	}
	
	func testIgnoresOtherFiles() throws {
		let otherURL = directory.appendingPathComponent("NotSVG.png")
		let otherOutputURL = directory.appendingPathComponent("NotSVG+UIImage.swift")
		try "other".write(to: otherURL, atomically: true, encoding: .utf8)
		
		let cli = CLI(arguments: [directory.path])
		try cli.run()
		
		XCTAssertFalse(FileManager.default.fileExists(atPath: otherOutputURL.path))
	}
}
