import XCTest
import VectorIO
import CoreGraphics


class SVGStyleTests: XCTestCase {
	func testParseHexColor() throws {
		let expected = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
		XCTAssertEqual(try? CGColor.parse("#f00"), expected)
		XCTAssertEqual(try? CGColor.parse("#ff0000"), expected)
	}
	
	func testParseRGBColor() throws {
		let expected = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
		XCTAssertEqual(try? CGColor.parse("rgb(255,0,0)"), expected)
	}
	
	func testParseNamedColor() throws {
		let expected = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
		XCTAssertEqual(try? CGColor.parse("red"), expected)
	}
}
