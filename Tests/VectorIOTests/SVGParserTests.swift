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
		
		XCTAssertEqual(svg.size, CGSize(width: 400, height: 110))
		XCTAssertEqual(svg.elements.count, 1)
		guard let element = svg.elements.first as? SVGRect else { XCTFail(); return }
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
		
		XCTAssertEqual(svg.size, CGSize(width: 400, height: 110))
		XCTAssertEqual(svg.elements.count, 1)
		guard let element = svg.elements.first as? SVGRect else { XCTFail(); return }
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
        
        XCTAssertEqual(svg.size, CGSize(width: 400, height: 180))
        XCTAssertEqual(svg.elements.count, 1)
        guard let element = svg.elements.first as? SVGRect else { XCTFail(); return }
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
        
        XCTAssertEqual(svg.size, CGSize(width: 400, height: 180))
        XCTAssertEqual(svg.elements.count, 1)
        guard let element = svg.elements.first as? SVGRect else { XCTFail(); return }
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
        
        XCTAssertEqual(svg.size, CGSize(width: 400, height: 180))
        XCTAssertEqual(svg.elements.count, 1)
        guard let element = svg.elements.first as? SVGRect else { XCTFail(); return }
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
		
		XCTAssertEqual(svg.size, CGSize(width: 100, height: 100))
		XCTAssertEqual(svg.elements.count, 1)
		guard let element = svg.elements.first as? SVGCircle else { XCTFail(); return }
		XCTAssertEqual(element.center, CGPoint(x: 50, y: 50))
		XCTAssertEqual(element.radius, 40)
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
		
		XCTAssertEqual(svg.size, CGSize(width: 500, height: 140))
		XCTAssertEqual(svg.elements.count, 1)
		guard let element = svg.elements.first as? SVGEllipse else { XCTFail(); return }
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
		
		XCTAssertEqual(svg.size, CGSize(width: 500, height: 210))
		XCTAssertEqual(svg.elements.count, 1)
		guard let element = svg.elements.first as? SVGLine else { XCTFail(); return }
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
		
		XCTAssertEqual(svg.size, CGSize(width: 500, height: 210))
		XCTAssertEqual(svg.elements.count, 1)
		guard let element = svg.elements.first as? SVGPolygon else { XCTFail(); return }
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
		
		XCTAssertEqual(svg.size, CGSize(width: 500, height: 210))
		XCTAssertEqual(svg.elements.count, 1)
		guard let element = svg.elements.first as? SVGPolygon else { XCTFail(); return }
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
		
		XCTAssertEqual(svg.size, CGSize(width: 500, height: 180))
		XCTAssertEqual(svg.elements.count, 1)
		guard let element = svg.elements.first as? SVGPolyline else { XCTFail(); return }
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
}
