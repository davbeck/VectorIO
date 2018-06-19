import XCTest
import VectorIO


class SVGParserTests: XCTestCase {
    // MARK - Rect
	
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
			stroke: CGColor(red: 0, green: 0, blue: 0, alpha: 1),
			strokeWidth: 3
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
			stroke: CGColor(red: 0, green: 0, blue: 0, alpha: 1),
			strokeWidth: 3
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
			strokeOpacity: 0.9
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
			stroke: CGColor(red: 1, green: 0, blue: 1, alpha: 1),
			strokeWidth: 5,
			opacity: 0.5
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
			stroke: CGColor(red: 1, green: 0, blue: 1, alpha: 1),
			strokeWidth: 5,
			opacity: 0.5
		))
    }
	
	
	// MARK - Circle
	
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
			stroke: CGColor(red: 0, green: 0, blue: 0, alpha: 1),
			strokeWidth: 3
		))
	}
	
	
	// MARK - Ellipse
	
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
			stroke: CGColor(red: 1, green: 0, blue: 1, alpha: 1),
			strokeWidth: 5,
			opacity: 0.5
		))
	}
	
	
	// MARK - Line
	
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
		guard let element = svg.children.first as? SVGLine else { XCTFail(); return }
		XCTAssertEqual(element.start, CGPoint(x: 0, y: 0))
		XCTAssertEqual(element.end, CGPoint(x: 200, y: 200))
		XCTAssertEqual(element.style, CSSStyle(
			stroke: CGColor(red: 1, green: 0, blue: 0, alpha: 1),
			strokeWidth: 2
		))
	}
	
	
	// MARK - Polygon
	
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
		guard let element = svg.children.first as? SVGPolygon else { XCTFail(); return }
		XCTAssertEqual(element.points, [
			CGPoint(x: 200, y: 10),
			CGPoint(x: 250, y: 190),
			CGPoint(x: 160, y: 210),
		])
		XCTAssertEqual(element.style, CSSStyle(
			fill: CGColor(red: 0, green: 1, blue: 0, alpha: 1)
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
		guard let element = svg.children.first as? SVGPolygon else { XCTFail(); return }
		XCTAssertEqual(element.points, [
			CGPoint(x: 100, y: 10),
			CGPoint(x: 40, y: 198),
			CGPoint(x: 190, y: 78),
			CGPoint(x: 10, y: 78),
			CGPoint(x: 160, y: 198),
		])
		XCTAssertEqual(element.style, CSSStyle(
			fill: CGColor(red: 0, green: 1, blue: 0, alpha: 1),
			fillRule: .evenOdd
		))
	}
	
	
	// MARK - Polyline
	
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
		guard let element = svg.children.first as? SVGPolyline else { XCTFail(); return }
		XCTAssertEqual(element.points, [
			CGPoint(x: 0, y: 40),
			CGPoint(x: 40, y: 40),
			CGPoint(x: 40, y: 80),
			CGPoint(x: 80, y: 80),
			CGPoint(x: 80, y: 120),
			CGPoint(x: 120, y: 120),
			CGPoint(x: 120, y: 160),
		])
		XCTAssertEqual(element.style, CSSStyle(
			fill: CGColor(red: 1, green: 1, blue: 1, alpha: 1),
			stroke: CGColor(red: 1, green: 0, blue: 0, alpha: 1),
			strokeWidth: 4
		))
	}
	
	
	// MARK - Path
	
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
		XCTAssertEqual(element.style, CSSStyle())
	}
	
	func testParseQuadraticBezierCurve() throws {
		let data = """
		<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
		<path fill="none" stroke="red"
		d="M 10,50
		   Q 25,25 40,50
		   T 70,50" />
		</svg>
		""".data(using: .utf8)!
		
		let svg = try SVGParser(data: data).parse()
		
		XCTAssertEqual(svg.children.count, 1)
		guard let element = svg.children.first as? SVGPath else { XCTFail(); return }
		XCTAssertEqual(element.definitions, [
			SVGPath.Definition.moveTo(CGPoint(x: 10, y: 50)),
			SVGPath.Definition.quadraticBezierCurve(control: CGPoint(x: 25, y: 25), end: CGPoint(x: 40, y: 50)),
			SVGPath.Definition.quadraticBezierCurve(control: CGPoint(x: 55, y: 75), end: CGPoint(x: 70, y: 50)),
			])
		XCTAssertEqual(element.style, CSSStyle(
			fill: CGColor.clear,
			stroke: CGColor(red: 1, green: 0, blue: 0, alpha: 1)
		))
	}
	
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
			SVGPath.Definition.arc(radius: CGPoint(x: 20, y: 20), angle: CGFloat(0), isLargeArc: false, isSweep: true, end: CGPoint(x: 50, y: 30)),
			SVGPath.Definition.arc(radius: CGPoint(x: 20, y: 20), angle: CGFloat(0), isLargeArc: false, isSweep: true, end: CGPoint(x: 90, y: 30)),
			SVGPath.Definition.quadraticBezierCurve(control: CGPoint(x: 90, y: 60), end: CGPoint(x: 50, y: 90)),
			SVGPath.Definition.quadraticBezierCurve(control: CGPoint(x: 10, y: 60), end: CGPoint(x: 10, y: 30)),
			SVGPath.Definition.closePath,
			])
		XCTAssertEqual(element.style, CSSStyle(
			fill: CGColor.clear,
			stroke: CGColor(red: 1, green: 0, blue: 0, alpha: 1)
		))
	}
	
	func testParseCubicBezierCurve() throws {
		let data = """
		<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
		<path fill="none" stroke="red"
		d="M 10,90
		   C 30,90 30,10 50,10
		   S 70,90 90,90" />
		</svg>
		""".data(using: .utf8)!
		
		let svg = try SVGParser(data: data).parse()
		
		XCTAssertEqual(svg.children.count, 1)
		guard let element = svg.children.first as? SVGPath else { XCTFail(); return }
		XCTAssertEqual(element.definitions, [
			SVGPath.Definition.moveTo(CGPoint(x: 10, y: 90)),
			SVGPath.Definition.cubicBezierCurve(controlStart: CGPoint(x: 30, y: 90), controlEnd: CGPoint(x: 30, y: 10), end: CGPoint(x: 50, y: 10)),
			SVGPath.Definition.cubicBezierCurve(controlStart: CGPoint(x: 70, y: 10), controlEnd: CGPoint(x: 70, y: 90), end: CGPoint(x: 90, y: 90)),
		])
		XCTAssertEqual(element.style, CSSStyle(
			fill: CGColor.clear,
			stroke: CGColor(red: 1, green: 0, blue: 0, alpha: 1)
		))
	}
	
	
	// MARK - Groups
	
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
			stroke: CGColor(red: 1, green: 0, blue: 0, alpha: 1),
			strokeWidth: 5
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
			stroke: CGColor(red: 1, green: 0, blue: 0, alpha: 1),
			strokeWidth: 5
		))
	}
	
	
	// MARK - ViewBox
	
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
	
	
	// MARK - Example SVGs
	
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
			stroke: CGColor.clear,
			strokeWidth: 1,
			fillRule: .evenOdd
		))
		
		guard element.children.count == 1 else { XCTFail(); return }
		
		guard let path = element.children[0] as? SVGPath else { XCTFail(); return }
		XCTAssertEqual(path.style, CSSStyle(
			fill: CGColor(red: 1, green: 0, blue: 0, alpha: 1),
			stroke: CGColor.clear,
			strokeWidth: 1,
			fillRule: .evenOdd
		))
	}
}
