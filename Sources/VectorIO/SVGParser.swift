import Foundation
import CoreGraphics


public class SVGParser: NSObject {
	public enum Error: Swift.Error {
		case missingSVGElement
	}
	
	fileprivate let xmlParser: XMLParser
	fileprivate var svg = SVG()
	fileprivate var parents: Array<SVGParentElement> = []
	fileprivate var currentParent: SVGParentElement {
		get {
			return parents.last ?? svg
		}
		set {
			if let index = parents.indices.last {
				parents[index] = newValue
			} else if let newValue = newValue as? SVG {
				svg = newValue
			}
		}
	}
	
	private init(_ parser: XMLParser) {
		xmlParser = parser
		super.init()
		
		xmlParser.delegate = self
	}
	
	public convenience init?(contentsOf url: URL) {
		guard let parser = XMLParser(contentsOf: url) else { return nil }
		self.init(parser)
	}
	
	public convenience init(data: Data) {
		self.init(XMLParser(data: data))
	}
	
	public convenience init(stream: InputStream) {
		self.init(XMLParser(stream: stream))
	}
	
	
	fileprivate var error: Swift.Error?
	public func parse() throws -> SVG {
		xmlParser.parse()
		if let error = self.error ?? xmlParser.parserError {
			throw error
		}
		
		return svg
	}
}


extension SVGParser: XMLParserDelegate {
	public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes: [String : String] = [:]) {
		do {
			switch elementName {
			case "svg":
				try parseSVG(attributes: attributes)
            case "rect":
                try parseRect(attributes: attributes)
			case "circle":
				try parseCircle(attributes: attributes)
			case "ellipse":
				try parseEllipse(attributes: attributes)
			case "line":
				try parseLine(attributes: attributes)
			case "polygon":
				try parsePolygon(attributes: attributes)
			case "polyline":
				try parsePolyline(attributes: attributes)
			case "path":
				try parsePath(attributes: attributes)
			case SVGGroup.elementName:
				try parseGroup(attributes: attributes)
			default:
				print("unrecognized element \(elementName)")
			}
		} catch {
			self.error = error
			xmlParser.abortParsing()
		}
	}
	
	public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		guard let element = parents.last, type(of: element).elementName == elementName else { return }
		parents.removeLast()
		currentParent.append(element)
	}
	
	fileprivate func parseSVG(attributes: [String : String]) throws {
		for (name, value) in attributes {
			switch name {
			case "width":
				svg.size.width = try CGFloat.parse(value)
			case "height":
				svg.size.height = try CGFloat.parse(value)
			case "viewBox":
				var separators = CharacterSet.whitespacesAndNewlines
				separators.insert(",")
				let coords = try value.components(separatedBy: separators).compactMap({ try CGFloat.parse($0) })
				guard coords.count == 4 else { throw ParseError.invalidNumber(String(value)) }
				
				svg.viewBox = CGRect(x: coords[0], y: coords[1], width: coords[2], height: coords[3])
			default:
				try parseElementAttribute(name: name, value: value, for: &svg)
			}
		}
		
		if attributes.keys.contains("viewBox") {
			if !attributes.keys.contains("width") {
				svg.size.width = svg.viewBox.width
			}
			if !attributes.keys.contains("height") {
				svg.size.height = svg.viewBox.height
			}
		} else {
			if attributes.keys.contains("width") {
				svg.viewBox.size.width = svg.size.width
			}
			if attributes.keys.contains("height") {
				svg.viewBox.size.height = svg.size.height
			}
		}
	}
    
    fileprivate func parseElementAttribute<E: SVGElement>(name: String, value: String, for element: inout E) throws {
        switch name {
        case "stroke":
			element.style = try CSSStyle(stroke: CGColor.parse(value))
			.merging(element.style)
        case "stroke-width":
			element.style = try CSSStyle(strokeWidth: CGFloat.parse(value))
				.merging(element.style)
		case "fill":
			element.style = try CSSStyle(fill: CGColor.parse(value))
				.merging(element.style)
		case "fill-rule":
			element.style = CSSStyle(fillRule: FillRule(rawValue: value))
				.merging(element.style)
			
		case "style":
			try element.style.merge(CSSStyle(definition: value))
			
        default:
            print("unrecognized attribute \(name)=\(value) on \(E.elementName)")
        }
    }
    
    fileprivate func parseRect(attributes: [String : String]) throws {
        var element = SVGRect()
        
        for (name, value) in attributes {
            switch name {
            case "x":
                element.frame.origin.x = try CGFloat.parse(value)
            case "y":
                element.frame.origin.y = try CGFloat.parse(value)
            case "width":
                element.frame.size.width = try CGFloat.parse(value)
            case "height":
                element.frame.size.height = try CGFloat.parse(value)
            case "rx":
                element.radiusX = try CGFloat.parse(value)
            case "ry":
                element.radiusY = try CGFloat.parse(value)
            default:
                try parseElementAttribute(name: name, value: value, for: &element)
            }
        }
		
        currentParent.append(element)
    }
	
	fileprivate func parseCircle(attributes: [String : String]) throws {
		var element = SVGEllipse()
		
		for (name, value) in attributes {
			switch name {
			case "cx":
				element.center.x = try CGFloat.parse(value)
			case "cy":
				element.center.y = try CGFloat.parse(value)
			case "r":
				let radius = try CGFloat.parse(value)
				element.radius = CGSize(width: radius, height: radius)
			default:
				try parseElementAttribute(name: name, value: value, for: &element)
			}
		}
		
		currentParent.append(element)
	}
	
	fileprivate func parseEllipse(attributes: [String : String]) throws {
		var element = SVGEllipse()
		
		for (name, value) in attributes {
			switch name {
			case "cx":
				element.center.x = try CGFloat.parse(value)
			case "cy":
				element.center.y = try CGFloat.parse(value)
			case "rx":
				element.radius.width = try CGFloat.parse(value)
			case "ry":
				element.radius.height = try CGFloat.parse(value)
			default:
				try parseElementAttribute(name: name, value: value, for: &element)
			}
		}
		
		currentParent.append(element)
	}
	
	fileprivate func parseLine(attributes: [String : String]) throws {
		var element = SVGLine()
		
		for (name, value) in attributes {
			switch name {
			case "x1":
				element.start.x = try CGFloat.parse(value)
			case "y1":
				element.start.y = try CGFloat.parse(value)
			case "x2":
				element.end.x = try CGFloat.parse(value)
			case "y2":
				element.end.y = try CGFloat.parse(value)
			default:
				try parseElementAttribute(name: name, value: value, for: &element)
			}
		}
		
		currentParent.append(element)
	}
	
	fileprivate func parsePolygon(attributes: [String : String]) throws {
		var element = SVGPolygon()
		
		for (name, value) in attributes {
			switch name {
			case "points":
				element.points = try value
					.components(separatedBy: .whitespacesAndNewlines)
					.map({ try CGPoint.parse($0) })
			default:
				try parseElementAttribute(name: name, value: value, for: &element)
			}
		}
		
		currentParent.append(element)
	}
	
	fileprivate func parsePolyline(attributes: [String : String]) throws {
		var element = SVGPolyline()
		
		for (name, value) in attributes {
			switch name {
			case "points":
				element.points = try value
					.components(separatedBy: .whitespacesAndNewlines)
					.map({ try CGPoint.parse($0) })
			default:
				try parseElementAttribute(name: name, value: value, for: &element)
			}
		}
		
		currentParent.append(element)
	}
	
	fileprivate func parsePath(attributes: [String : String]) throws {
		var element = SVGPath()
		
		for (name, value) in attributes {
			switch name {
			case "d":
				element.definitions = try SVGPath.Definition.parse(value)
			default:
				try parseElementAttribute(name: name, value: value, for: &element)
			}
		}
		
		currentParent.append(element)
	}
	
	fileprivate func parseGroup(attributes: [String : String]) throws {
		var element = SVGGroup()
		
		for (name, value) in attributes {
			switch name {
			default:
				try parseElementAttribute(name: name, value: value, for: &element)
			}
		}
		
		parents.append(element)
	}
}

extension Unicode.Scalar {
	var isWhitespaceOrNewline: Bool {
		return CharacterSet.whitespacesAndNewlines.contains(self)
	}
}



