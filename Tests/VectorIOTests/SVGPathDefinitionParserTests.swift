import XCTest
import VectorIO


class SVGPathDefinitionParserTests: XCTestCase {
	func testParseQuadraticBezierCurve() throws {
		let result = try SVGPathDefinitionParser("M 10,50Q 25,25 40,50T 70,50").parse()
		
		XCTAssertEqual(result, [
			SVGPath.Definition.moveTo(CGPoint(x: 10, y: 50)),
			SVGPath.Definition.quadraticBezierCurve(control: CGPoint(x: 25, y: 25), end: CGPoint(x: 40, y: 50)),
			SVGPath.Definition.quadraticBezierCurve(control: CGPoint(x: 55, y: 75), end: CGPoint(x: 70, y: 50)),
		])
	}
	
	func testParseCubicBezierCurve() throws {
		let result = try SVGPathDefinitionParser("M 10,90C 30,90 30,10 50,10S 70,90 90,90").parse()
		
		XCTAssertEqual(result, [
			SVGPath.Definition.moveTo(CGPoint(x: 10, y: 90)),
			SVGPath.Definition.cubicBezierCurve(controlStart: CGPoint(x: 30, y: 90), controlEnd: CGPoint(x: 30, y: 10), end: CGPoint(x: 50, y: 10)),
			SVGPath.Definition.cubicBezierCurve(controlStart: CGPoint(x: 70, y: 10), controlEnd: CGPoint(x: 70, y: 90), end: CGPoint(x: 90, y: 90)),
		])
	}
	
	func testParseCombinedNegatives() throws {
		let result = try SVGPathDefinitionParser("L-5-5").parse()
		
		XCTAssertEqual(result, [
			SVGPath.Definition.lineTo(CGPoint(x: -5, y: -5)),
		])
	}
	
	func testParseCombinedDecimals() throws {
		let result = try SVGPathDefinitionParser("L.5.5").parse()
		
		XCTAssertEqual(result, [
			SVGPath.Definition.lineTo(CGPoint(x: 0.5, y: 0.5)),
		])
	}
	
	
	// MARK: - Repeated Values
	
	func testRepeatedS() throws {
		let result = try SVGPathDefinitionParser("S0 10 10 10 30 10 20 0").parse()
		
		XCTAssertEqual(result, [
			SVGPath.Definition.cubicBezierCurve(controlStart: CGPoint(x: 0, y: 0), controlEnd: CGPoint(x: 0, y: 10.0), end: CGPoint(x: 10, y: 10)),
			SVGPath.Definition.cubicBezierCurve(controlStart: CGPoint(x: 20, y: 10), controlEnd: CGPoint(x: 30, y: 10), end: CGPoint(x: 20, y: 0)),
		])
	}
	
	func testRepeatedC() throws {
		let result = try SVGPathDefinitionParser("C0 0 0 10 10 10 20 10 30 10 20 0").parse()
		
		XCTAssertEqual(result, [
			SVGPath.Definition.cubicBezierCurve(controlStart: CGPoint(x: 0, y: 0), controlEnd: CGPoint(x: 0, y: 10.0), end: CGPoint(x: 10, y: 10)),
			SVGPath.Definition.cubicBezierCurve(controlStart: CGPoint(x: 20, y: 10), controlEnd: CGPoint(x: 30, y: 10), end: CGPoint(x: 20, y: 0)),
		])
	}
	
	func testRepeatedL() throws {
		let result = try SVGPathDefinitionParser("L10 10 20 30 30 20").parse()
		
		XCTAssertEqual(result, [
			SVGPath.Definition.lineTo(CGPoint(x: 10, y: 10)),
			SVGPath.Definition.lineTo(CGPoint(x: 20, y: 30)),
			SVGPath.Definition.lineTo(CGPoint(x: 30, y: 20)),
		])
	}
	
	func testRepeatedH() throws {
		let result = try SVGPathDefinitionParser("H10 20 30").parse()
		
		XCTAssertEqual(result, [
			SVGPath.Definition.lineTo(CGPoint(x: 10, y: 0)),
			SVGPath.Definition.lineTo(CGPoint(x: 20, y: 0)),
			SVGPath.Definition.lineTo(CGPoint(x: 30, y: 0)),
		])
	}
	
	func testRepeatedV() throws {
		let result = try SVGPathDefinitionParser("V10 20 30").parse()
		
		XCTAssertEqual(result, [
			SVGPath.Definition.lineTo(CGPoint(x: 0, y: 10)),
			SVGPath.Definition.lineTo(CGPoint(x: 0, y: 20)),
			SVGPath.Definition.lineTo(CGPoint(x: 0, y: 30)),
		])
	}
}
