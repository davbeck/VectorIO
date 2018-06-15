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
		XCTAssertEqual(element.style.rules, [
			.fill(CGColor(red: 0, green: 0, blue: 1, alpha: 1)),
			.strokeWidth(3),
			.stroke(CGColor(red: 0, green: 0, blue: 0, alpha: 1)),
		])
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
        XCTAssertEqual(element.style.rules, [
            .fill(CGColor(red: 0, green: 0, blue: 1, alpha: 1)),
            .stroke(CGColor(red: 1, green: 0, blue: 1, alpha: 1)),
            .strokeWidth(5),
            .fillOpacity(0.1),
            .strokeOpacity(0.9),
        ])
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
        XCTAssertEqual(element.style.rules, [
            .fill(CGColor(red: 0, green: 0, blue: 1, alpha: 1)),
            .stroke(CGColor(red: 1, green: 0, blue: 1, alpha: 1)),
            .strokeWidth(5),
            .opacity(0.5),
        ])
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
        XCTAssertEqual(element.style.rules, [
            .fill(CGColor(red: 0, green: 0, blue: 1, alpha: 1)),
            .stroke(CGColor(red: 1, green: 0, blue: 1, alpha: 1)),
            .strokeWidth(5),
            .opacity(0.5),
        ])
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
		XCTAssertEqual(Set(element.style.rules), [
			.stroke(CGColor(red: 0, green: 0, blue: 0, alpha: 1)),
			.strokeWidth(3),
			.fill(CGColor(red: 1, green: 0, blue: 0, alpha: 1)),
			])
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
		XCTAssertEqual(element.style.rules, [
			.fill(CGColor(red: 0, green: 0, blue: 1, alpha: 1)),
			.stroke(CGColor(red: 1, green: 0, blue: 1, alpha: 1)),
			.strokeWidth(5),
			.opacity(0.5),
			])
	}
}
