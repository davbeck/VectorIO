import XCTest
import VectorIO


class SVGParserTests: XCTestCase {

	// MARK: - Rect
	
	func testParseRect() throws {
		let data = """
		<svg width="400" height="110">
		<rect width="300" height="100" style="fill:rgb(0,0,255);stroke-width:3;stroke:rgb(0,0,0)" />
		</svg>
		""".data(using: .utf8)!
		
		let parser = SVGParser(data: data)
		let svg = try parser.parse()
		
		XCTAssertEqual(svg.children.count, 1)
		guard let element = svg.children.first as? SVGRect else { XCTFail(); return }
		XCTAssertEqual(element.frame, CGRect(x: 0, y: 0, width: 300, height: 100))
		XCTAssertEqual(element.style, CSSStyle(
			fill: CGColor(red: 0, green: 0, blue: 1, alpha: 1),
			fillOpacity: 1,
			stroke: CGColor(red: 0, green: 0, blue: 0, alpha: 1),
			strokeWidth: 3,
			strokeOpacity: 1,
			opacity: 1,
			fillRule: .evenOdd
		))
	}
	
	func testParseRectWithConflictingStyles() throws {
		let data = """
		<svg width="400" height="110">
		<rect width="300" height="100" fill="#ff0000" stroke="#00ff00" style="fill:rgb(0,0,255);stroke-width:3;stroke:rgb(0,0,0)" />
		</svg>
		""".data(using: .utf8)!
		
		let parser = SVGParser(data: data)
		let svg = try parser.parse()
		
		XCTAssertEqual(svg.children.count, 1)
		guard let element = svg.children.first as? SVGRect else { XCTFail(); return }
		XCTAssertEqual(element.frame, CGRect(x: 0, y: 0, width: 300, height: 100))
		XCTAssertEqual(element.style, CSSStyle(
			fill: CGColor(red: 0, green: 0, blue: 1, alpha: 1),
			fillOpacity: 1,
			stroke: CGColor(red: 0, green: 0, blue: 0, alpha: 1),
			strokeWidth: 3,
			strokeOpacity: 1,
			opacity: 1,
			fillRule: .evenOdd
		))
	}
	
	func testParseTransparentRectStrokeAndFill() throws {
		let data = """
		<svg width="400" height="180">
		<rect x="50" y="20" width="150" height="150"
		style="fill:#0000ff;stroke:#FF00FF;stroke-width:5;fill-opacity:0.1;stroke-opacity:0.9" />
		</svg>
		""".data(using: .utf8)!
		
		let parser = SVGParser(data: data)
		let svg = try parser.parse()
		
		XCTAssertEqual(svg.children.count, 1)
		guard let element = svg.children.first as? SVGRect else { XCTFail(); return }
		XCTAssertEqual(element.frame, CGRect(x: 50, y: 20, width: 150, height: 150))
		XCTAssertEqual(element.style, CSSStyle(
			fill: CGColor(red: 0, green: 0, blue: 1, alpha: 1),
			fillOpacity: 0.1,
			stroke: CGColor(red: 1, green: 0, blue: 1, alpha: 1),
			strokeWidth: 5,
			strokeOpacity: 0.9,
			opacity: 1,
			fillRule: .evenOdd
		))
	}
	
	func testParseTransparentRect() throws {
		let data = """
		<svg width="400" height="180">
		<rect x="50" y="20" width="150" height="150"
		style="fill:#0000ff;stroke:#FF00FF;stroke-width:5;opacity:0.5" />
		</svg>
		""".data(using: .utf8)!
		
		let parser = SVGParser(data: data)
		let svg = try parser.parse()
		
		XCTAssertEqual(svg.children.count, 1)
		guard let element = svg.children.first as? SVGRect else { XCTFail(); return }
		XCTAssertEqual(element.frame, CGRect(x: 50, y: 20, width: 150, height: 150))
		XCTAssertEqual(element.style, CSSStyle(
			fill: CGColor(red: 0, green: 0, blue: 1, alpha: 1),
			fillOpacity: 1,
			stroke: CGColor(red: 1, green: 0, blue: 1, alpha: 1),
			strokeWidth: 5,
			strokeOpacity: 1,
			opacity: 0.5,
			fillRule: .evenOdd
		))
	}
	
	func testParseRoundedRect() throws {
		let data = """
		<svg width="400" height="180">
		<rect x="50" y="20" rx="20" ry="20" width="150" height="150"
		style="fill:#0000ff;stroke:#FF00FF;stroke-width:5;opacity:0.5" />
		</svg>
		""".data(using: .utf8)!
		
		let parser = SVGParser(data: data)
		let svg = try parser.parse()
		
		XCTAssertEqual(svg.children.count, 1)
		guard let element = svg.children.first as? SVGRect else { XCTFail(); return }
		XCTAssertEqual(element.frame, CGRect(x: 50, y: 20, width: 150, height: 150))
		XCTAssertEqual(element.radiusX, 20)
		XCTAssertEqual(element.radiusY, 20)
		XCTAssertEqual(element.style, CSSStyle(
			fill: CGColor(red: 0, green: 0, blue: 1, alpha: 1),
			fillOpacity: 1,
			stroke: CGColor(red: 1, green: 0, blue: 1, alpha: 1),
			strokeWidth: 5,
			strokeOpacity: 1,
			opacity: 0.5,
			fillRule: .evenOdd
		))
	}
	
	
	// MARK: - Circle
	
	func testParseCircle() throws {
		let data = """
		<svg height="100" width="100">
		<circle cx="50" cy="50" r="40" stroke="#000" stroke-width="3" fill="#ff0000" />
		</svg>
		""".data(using: .utf8)!
		
		let parser = SVGParser(data: data)
		let svg = try parser.parse()
		
		XCTAssertEqual(svg.children.count, 1)
		guard let element = svg.children.first as? SVGEllipse else { XCTFail(); return }
		XCTAssertEqual(element.center, CGPoint(x: 50, y: 50))
		XCTAssertEqual(element.radius, CGSize(width: 40, height: 40))
		XCTAssertEqual(element.style, CSSStyle(
			fill: CGColor(red: 1, green: 0, blue: 0, alpha: 1),
			fillOpacity: 1,
			stroke: CGColor(red: 0, green: 0, blue: 0, alpha: 1),
			strokeWidth: 3,
			strokeOpacity: 1,
			opacity: 1,
			fillRule: .evenOdd
		))
	}
	
	
	// MARK: - Ellipse
	
	func testParseEllipse() throws {
		let data = """
		<svg height="140" width="500">
		<ellipse cx="200" cy="80" rx="100" ry="50"
		style="fill:#0000ff;stroke:#FF00FF;stroke-width:5;opacity:0.5" />
		</svg>
		""".data(using: .utf8)!
		
		let parser = SVGParser(data: data)
		let svg = try parser.parse()
		
		XCTAssertEqual(svg.children.count, 1)
		guard let element = svg.children.first as? SVGEllipse else { XCTFail(); return }
		XCTAssertEqual(element.center, CGPoint(x: 200, y: 80))
		XCTAssertEqual(element.radius, CGSize(width: 100, height: 50))
		XCTAssertEqual(element.style, CSSStyle(
			fill: CGColor(red: 0, green: 0, blue: 1, alpha: 1),
			fillOpacity: 1,
			stroke: CGColor(red: 1, green: 0, blue: 1, alpha: 1),
			strokeWidth: 5,
			strokeOpacity: 1,
			opacity: 0.5,
			fillRule: .evenOdd
		))
	}
	
	
	// MARK: - Line
	
	func testParseLine() throws {
		let data = """
		<svg height="210" width="500">
		<line x1="0" y1="0" x2="200" y2="200"
		style="stroke:rgb(255,0,0);stroke-width:2" />
		</svg>
		""".data(using: .utf8)!
		
		let parser = SVGParser(data: data)
		let svg = try parser.parse()
		
		XCTAssertEqual(svg.children.count, 1)
		guard let element = svg.children.first as? SVGPath else { XCTFail(); return }
		XCTAssertEqual(element.definitions, [
			.moveTo(CGPoint(x: 0, y: 0)),
			.lineTo(CGPoint(x: 200, y: 200)),
		])
		XCTAssertEqual(element.style, CSSStyle(
			fill: .black,
			fillOpacity: 1,
			stroke: CGColor(red: 1, green: 0, blue: 0, alpha: 1),
			strokeWidth: 2,
			strokeOpacity: 1,
			opacity: 1,
			fillRule: .evenOdd
		))
	}
	
	
	// MARK: - Polygon
	
	func testParsePolygon() throws {
		let data = """
		<svg height="210" width="500">
		<polygon points="200,10 250,190 160,210"
		style="fill:lime" />
		</svg>
		""".data(using: .utf8)!
		
		let parser = SVGParser(data: data)
		let svg = try parser.parse()
		
		XCTAssertEqual(svg.children.count, 1)
		guard let element = svg.children.first as? SVGPath else { XCTFail(); return }
		XCTAssertEqual(element.definitions, [
			SVGPath.Definition.moveTo(CGPoint(x: 200, y: 10)),
			SVGPath.Definition.lineTo(CGPoint(x: 250, y: 190)),
			SVGPath.Definition.lineTo(CGPoint(x: 160, y: 210)),
			SVGPath.Definition.closePath,
		])
		XCTAssertEqual(element.style, CSSStyle(
			fill: CGColor(red: 0, green: 1, blue: 0, alpha: 1),
			fillOpacity: 1,
			stroke: .clear,
			strokeWidth: 1,
			strokeOpacity: 1,
			opacity: 1,
			fillRule: .evenOdd
		))
	}
	
	func testParseEvenOddPolygon() throws {
		let data = """
		<svg height="210" width="500">
		<polygon points="100,10 40,198 190,78 10,78 160,198"
		style="fill:lime;fill-rule:evenodd;" />
		</svg>
		""".data(using: .utf8)!
		
		let parser = SVGParser(data: data)
		let svg = try parser.parse()
		
		XCTAssertEqual(svg.children.count, 1)
		guard let element = svg.children.first as? SVGPath else { XCTFail(); return }
		XCTAssertEqual(element.definitions, [
			SVGPath.Definition.moveTo(CGPoint(x: 100, y: 10)),
			SVGPath.Definition.lineTo(CGPoint(x: 40, y: 198)),
			SVGPath.Definition.lineTo(CGPoint(x: 190, y: 78)),
			SVGPath.Definition.lineTo(CGPoint(x: 10, y: 78)),
			SVGPath.Definition.lineTo(CGPoint(x: 160, y: 198)),
			SVGPath.Definition.closePath,
		])
		XCTAssertEqual(element.style, CSSStyle(
			fill: CGColor(red: 0, green: 1, blue: 0, alpha: 1),
			fillOpacity: 1,
			stroke: .clear,
			strokeWidth: 1,
			strokeOpacity: 1,
			opacity: 1,
			fillRule: .evenOdd
		))
	}
	
	
	// MARK: - Polyline
	
	func testParsePolyline() throws {
		let data = """
		<svg height="180" width="500">
		<polyline points="0,40 40,40 40,80 80,80 80,120 120,120 120,160"
		style="fill:white;stroke:red;stroke-width:4" />
		</svg>
		""".data(using: .utf8)!
		
		let parser = SVGParser(data: data)
		let svg = try parser.parse()
		
		XCTAssertEqual(svg.children.count, 1)
		guard let element = svg.children.first as? SVGPath else { XCTFail(); return }
		XCTAssertEqual(element.definitions, [
			SVGPath.Definition.moveTo(CGPoint(x: 0, y: 40)),
			SVGPath.Definition.lineTo(CGPoint(x: 40, y: 40)),
			SVGPath.Definition.lineTo(CGPoint(x: 40, y: 80)),
			SVGPath.Definition.lineTo(CGPoint(x: 80, y: 80)),
			SVGPath.Definition.lineTo(CGPoint(x: 80, y: 120)),
			SVGPath.Definition.lineTo(CGPoint(x: 120, y: 120)),
			SVGPath.Definition.lineTo(CGPoint(x: 120, y: 160)),
		])
		XCTAssertEqual(element.style, CSSStyle(
			fill: CGColor(red: 1, green: 1, blue: 1, alpha: 1),
			fillOpacity: 1,
			stroke: CGColor(red: 1, green: 0, blue: 0, alpha: 1),
			strokeWidth: 4,
			strokeOpacity: 1,
			opacity: 1,
			fillRule: .evenOdd
		))
	}
	
	
	// MARK: - Path
	
	func testParsePath() throws {
		let data = """
		<svg height="210" width="400">
		<path d="M150 0 L75 200 L225 200 Z" />
		</svg>
		""".data(using: .utf8)!
		
		let parser = SVGParser(data: data)
		let svg = try parser.parse()
		
		XCTAssertEqual(svg.children.count, 1)
		guard let element = svg.children.first as? SVGPath else { XCTFail(); return }
		XCTAssertEqual(element.definitions, [
			SVGPath.Definition.moveTo(CGPoint(x: 150, y: 0)),
			SVGPath.Definition.lineTo(CGPoint(x: 75, y: 200)),
			SVGPath.Definition.lineTo(CGPoint(x: 225, y: 200)),
			SVGPath.Definition.closePath,
		])
		XCTAssertEqual(element.style, CSSStyle.defaults)
	}
	
	
	// MARK: - Groups
	
	func testParseGroup() throws {
		let data = """
		<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
		  <g fill="white" stroke="red" stroke-width="5">
			<circle cx="40" cy="40" r="25" />
			<circle cx="60" cy="60" r="25" fill="blue" />
		  </g>
		</svg>
		""".data(using: .utf8)!
		
		let svg = try SVGParser(data: data).parse()
		
		XCTAssertEqual(svg.children.count, 1)
		guard let element = svg.children.first as? SVGGroup else { XCTFail(); return }
		XCTAssertEqual(element.style, CSSStyle(
			fill: CGColor(red: 1, green: 1, blue: 1, alpha: 1),
			fillOpacity: 1,
			stroke: CGColor(red: 1, green: 0, blue: 0, alpha: 1),
			strokeWidth: 5,
			strokeOpacity: 1,
			opacity: 1,
			fillRule: .evenOdd
		))
		
		guard element.children.count == 2 else { XCTFail(); return }
		
		guard let circle1 = element.children[0] as? SVGEllipse else { XCTFail(); return }
		XCTAssertEqual(circle1.center, CGPoint(x: 40, y: 40))
		XCTAssertEqual(circle1.radius, CGSize(width: 25, height: 25))
		XCTAssertEqual(circle1.style, element.style)
		
		guard let circle2 = element.children[1] as? SVGEllipse else { XCTFail(); return }
		XCTAssertEqual(circle2.center, CGPoint(x: 60, y: 60))
		XCTAssertEqual(circle2.radius, CGSize(width: 25, height: 25))
		XCTAssertEqual(circle2.style, CSSStyle(
			fill: CGColor(red: 0, green: 0, blue: 1, alpha: 1),
			fillOpacity: 1,
			stroke: CGColor(red: 1, green: 0, blue: 0, alpha: 1),
			strokeWidth: 5,
			strokeOpacity: 1,
			opacity: 1,
			fillRule: .evenOdd
		))
	}
	
	
	// MARK: - ViewBox
	
	func testViewBoxWithoutSize() throws {
		let data = """
		<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
		</svg>
		""".data(using: .utf8)!
		
		let svg = try SVGParser(data: data).parse()
		
		XCTAssertEqual(svg.size, CGSize(width: 100, height: 100))
		XCTAssertEqual(svg.viewBox, CGRect(x: 0, y: 0, width: 100, height: 100))
	}
	
	func testSizeWithoutViewBox() throws {
		let data = """
		<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg">
		</svg>
		""".data(using: .utf8)!
		
		let svg = try SVGParser(data: data).parse()
		
		XCTAssertEqual(svg.size, CGSize(width: 100, height: 100))
		XCTAssertEqual(svg.viewBox, CGRect(x: 0, y: 0, width: 100, height: 100))
	}
	
	func testSizeAndViewBox() throws {
		let data = """
		<svg width="100" height="100" viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
		</svg>
		""".data(using: .utf8)!
		
		let svg = try SVGParser(data: data).parse()
		
		XCTAssertEqual(svg.size, CGSize(width: 100, height: 100))
		XCTAssertEqual(svg.viewBox, CGRect(x: 0, y: 0, width: 200, height: 200))
	}
	
	func testSizeInPx() throws {
		let data = """
		<svg width="14px" height="14px" viewBox="0 0 14 14" xmlns="http://www.w3.org/2000/svg">
		</svg>
		""".data(using: .utf8)!
		
		let svg = try SVGParser(data: data).parse()
		
		XCTAssertEqual(svg.size, CGSize(width: 14, height: 14))
		XCTAssertEqual(svg.viewBox, CGRect(x: 0, y: 0, width: 14, height: 14))
	}
	
	
	// MARK: - Example SVGs
	
	func testParseHeart() throws {
		let data = """
		<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
		<path fill="none" stroke="red"
		d="M 10,30
		A 20,20 0,0,1 50,30
		A 20,20 0,0,1 90,30
		Q 90,60 50,90
		Q 10,60 10,30 z" />
		</svg>
		""".data(using: .utf8)!
		
		let svg = try SVGParser(data: data).parse()
		
		XCTAssertEqual(svg.children.count, 1)
		guard let element = svg.children.first as? SVGPath else { XCTFail(); return }
		XCTAssertEqual(element.definitions, [
			SVGPath.Definition.moveTo(CGPoint(x: 10, y: 30)),
			SVGPath.Definition.cubicBezierCurve(controlStart: CGPoint(x: 41.038300489879994, y: 10.0), controlEnd: CGPoint(x: 50.0, y: 18.961699510119995), end: CGPoint(x: 50.0, y: 29.999999999999996)),
			SVGPath.Definition.cubicBezierCurve(controlStart: CGPoint(x: 50.0, y: 41.038300489879994), controlEnd: CGPoint(x: 41.03830048988001, y: 50.0), end: CGPoint(x: 30.000000000000007, y: 50.0)),
			SVGPath.Definition.cubicBezierCurve(controlStart: CGPoint(x: 81.03830048988, y: 10.0), controlEnd: CGPoint(x: 90.0, y: 18.961699510119995), end: CGPoint(x: 90.0, y: 29.999999999999996)),
			SVGPath.Definition.cubicBezierCurve(controlStart: CGPoint(x: 90.0, y: 41.038300489879994), controlEnd: CGPoint(x: 81.03830048988, y: 50.0), end: CGPoint(x: 70.0, y: 50.0)),
			SVGPath.Definition.quadraticBezierCurve(control: CGPoint(x: 90, y: 60), end: CGPoint(x: 50, y: 90)),
			SVGPath.Definition.quadraticBezierCurve(control: CGPoint(x: 10, y: 60), end: CGPoint(x: 10, y: 30)),
			SVGPath.Definition.closePath,
		])
		XCTAssertEqual(element.style, CSSStyle(
			fill: CGColor.clear,
			fillOpacity: 1,
			stroke: CGColor(red: 1, green: 0, blue: 0, alpha: 1),
			strokeWidth: 1,
			strokeOpacity: 1,
			opacity: 1,
			fillRule: .evenOdd
		))
	}
	
	func testTag() throws {
		let data = """
		<?xml version="1.0" encoding="UTF-8"?>
		<svg width="14px" height="14px" viewBox="0 0 14 14" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
			<!-- Generator: Sketch 50.2 (55047) - http://www.bohemiancoding.com/sketch -->
			<title>tag</title>
			<desc>Created with Sketch.</desc>
			<defs></defs>
			<g id="tag" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
				<path d="M6.22780584,1.22780584 L12.9500281,7.95002806 C13.2537692,8.25376917 13.2537692,8.74623083 12.9500281,9.04997194 L9.04997194,12.9500281 C8.74623083,13.2537692 8.25376917,13.2537692 7.95002806,12.9500281 L1.22780584,6.22780584 C1.08194421,6.08194421 1,5.88411339 1,5.6778339 L1,1.77777778 C1,1.34822297 1.34822297,1 1.77777778,1 L5.6778339,1 C5.88411339,1 6.08194421,1.08194421 6.22780584,1.22780584 Z M3.5,4.66666667 C4.14433221,4.66666667 4.66666667,4.14433221 4.66666667,3.5 C4.66666667,2.85566779 4.14433221,2.33333333 3.5,2.33333333 C2.85566779,2.33333333 2.33333333,2.85566779 2.33333333,3.5 C2.33333333,4.14433221 2.85566779,4.66666667 3.5,4.66666667 Z" id="Combined-Shape" fill="#ff0000"></path>
			</g>
		</svg>
		""".data(using: .utf8)!
		
		let svg = try SVGParser(data: data).parse()
		
		XCTAssertEqual(svg.children.count, 1)
		guard let element = svg.children.first as? SVGGroup else { XCTFail(); return }
		XCTAssertEqual(element.style, CSSStyle(
			fill: CGColor.clear,
			fillOpacity: 1,
			stroke: CGColor.clear,
			strokeWidth: 1,
			strokeOpacity: 1,
			opacity: 1,
			fillRule: .evenOdd
		))
		
		guard element.children.count == 1 else { XCTFail(); return }
		
		guard let path = element.children[0] as? SVGPath else { XCTFail(); return }
		XCTAssertEqual(path.style, CSSStyle(
			fill: CGColor(red: 1, green: 0, blue: 0, alpha: 1),
			fillOpacity: 1,
			stroke: CGColor.clear,
			strokeWidth: 1,
			strokeOpacity: 1,
			opacity: 1,
			fillRule: .evenOdd
		))
	}
	
	func testCopyright() throws {
		let data = """
		<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M10.08 10.86c.05-.33.16-.62.3-.87s.34-.46.59-.62c.24-.15.54-.22.91-.23.23.01.44.05.63.13.2.09.38.21.52.36s.25.33.34.53.13.42.14.64h1.79c-.02-.47-.11-.9-.28-1.29s-.4-.73-.7-1.01-.66-.5-1.08-.66-.88-.23-1.39-.23c-.65 0-1.22.11-1.7.34s-.88.53-1.2.92-.56.84-.71 1.36S8 11.29 8 11.87v.27c0 .58.08 1.12.23 1.64s.39.97.71 1.35.72.69 1.2.91 1.05.34 1.7.34c.47 0 .91-.08 1.32-.23s.77-.36 1.08-.63.56-.58.74-.94.29-.74.3-1.15h-1.79c-.01.21-.06.4-.15.58s-.21.33-.36.46-.32.23-.52.3c-.19.07-.39.09-.6.1-.36-.01-.66-.08-.89-.23-.25-.16-.45-.37-.59-.62s-.25-.55-.3-.88-.08-.67-.08-1v-.27c0-.35.03-.68.08-1.01zM12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z"/></svg>
		""".data(using: .utf8)!
		
		let svg = try SVGParser(data: data).parse()
		
		XCTAssertEqual(svg.children.count, 1)
		guard let element = svg.children.first as? SVGPath else { XCTFail(); return }
		XCTAssertEqual(element.style, CSSStyle.defaults)
	}
	
	func testAdd() throws {
		let data = """
		<?xml version="1.0" encoding="UTF-8"?>
		<svg width="22px" height="22px" viewBox="0 0 22 22" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
			<!-- Generator: Sketch 50.2 (55047) - http://www.bohemiancoding.com/sketch -->
			<title>AddContent</title>
			<desc>Created with Sketch.</desc>
			<defs></defs>
			<g id="AddContent" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
				<circle id="Oval" stroke="#319ACF" cx="11" cy="11" r="10.5"></circle>
				<polygon id="Plus" fill="#319ACF" points="16.5 11.5 11.5 11.5 11.5 16.5 10.5 16.5 10.5 11.5 5.5 11.5 5.5 10.5 10.5 10.5 10.5 5.5 11.5 5.5 11.5 10.5 16.5 10.5"></polygon>
			</g>
		</svg>
		""".data(using: .utf8)!
		
		let svg = try SVGParser(data: data).parse()
		
		XCTAssertEqual(svg.children.count, 1)
		guard let element = svg.children.first as? SVGGroup else { XCTFail(); return }
		XCTAssertEqual(element.children.count, 2)
	}
	
	func testCloud() throws {
		let data = """
		<?xml version="1.0" encoding="UTF-8"?>
		<svg width="45px" height="30px" viewBox="0 0 45 30" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
			<!-- Generator: Sketch 50.2 (55047) - http://www.bohemiancoding.com/sketch -->
			<title>login-cloud1</title>
			<desc>Created with Sketch.</desc>
			<defs></defs>
			<g id="login-cloud1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" opacity="0.4">
				<circle id="Oval-Copy-6" fill="#FFFFFF" fill-rule="nonzero" cx="15" cy="15" r="15"></circle>
				<circle id="Oval-Copy-7" fill="#FFFFFF" fill-rule="nonzero" cx="34" cy="19" r="11"></circle>
			</g>
		</svg>
		""".data(using: .utf8)!
		
		let svg = try SVGParser(data: data).parse()
		
		XCTAssertEqual(svg.children.count, 1)
		guard let element = svg.children.first as? SVGGroup else { XCTFail(); return }
		XCTAssertEqual(element.children.count, 2)
		
		XCTAssertEqual(element.children[0].style.opacity, 0.4)
	}
}
