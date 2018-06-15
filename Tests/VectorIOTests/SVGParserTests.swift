import XCTest
import VectorIO


class SVGParserTests: XCTestCase {
	func testParseRect() throws {
		let data = """
		<svg width="400" height="110">
		<rect width="300" height="100" style="fill:rgb(0,0,255);stroke-width:3;stroke:rgb(0,0,0)" />
		</svg>
		""".data(using: .utf8)!
		
		let parser = SVGParser(data: data)
		let svg = try parser.parse()
		
		XCTAssertEqual(svg.size, CGSize(width: 400, height: 110))
		XCTAssertEqual(svg.elements.count, 1)
		let element = svg.elements[0]
		XCTAssertEqual(element.path, CGPath(rect: CGRect(x: 0, y: 0, width: 300, height: 100), transform: nil))
		XCTAssertEqual(element.style.rules, [
			.fill(CGColor(red: 0, green: 0, blue: 1, alpha: 1)),
			.strokeWidth(3),
			.stroke(CGColor(red: 0, green: 0, blue: 0, alpha: 1)),
		])
	}
}
