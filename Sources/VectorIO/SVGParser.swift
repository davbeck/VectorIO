import Foundation
import CoreGraphics


public class SVGParser: NSObject {
	fileprivate let xmlParser: XMLParser
	fileprivate var svg = SVG()
	
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
			default:
				print("unrecognized element \(elementName)")
			}
		} catch {
			self.error = error
			xmlParser.abortParsing()
		}
	}
	
	fileprivate func parseSVG(attributes: [String : String]) throws {
		for (name, value) in attributes {
			switch name {
			case "width":
				svg.size.width = try CGFloat.parse(value)
			case "height":
				svg.size.height = try CGFloat.parse(value)
			default:
				print("unrecognized attribute \(name)=\(value) on svg")
			}
		}
	}
    
    fileprivate func parseElementAttribute<E: SVGElement>(name: String, value: String, for element: inout E) throws {
        switch name {
        case "stroke":
            element.style.stroke = try CGColor.parse(value)
        case "stroke-width":
            element.style.strokeWidth = try CGFloat.parse(value)
        case "fill":
            element.style.fill = try CGColor.parse(value)
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
            case "style":
                element.style = try CSSStyle(definition: value)
            default:
                try parseElementAttribute(name: name, value: value, for: &element)
            }
        }
        
        svg.elements.append(element)
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
			case "style":
				element.style = try CSSStyle(definition: value)
			default:
				try parseElementAttribute(name: name, value: value, for: &element)
			}
		}
		
		svg.elements.append(element)
	}
	
	fileprivate func parseCircle(attributes: [String : String]) throws {
		var element = SVGCircle()
		
		for (name, value) in attributes {
			switch name {
			case "cx":
				element.center.x = try CGFloat.parse(value)
			case "cy":
				element.center.y = try CGFloat.parse(value)
			case "r":
				element.radius = try CGFloat.parse(value)
			case "style":
				element.style = try CSSStyle(definition: value)
			default:
				try parseElementAttribute(name: name, value: value, for: &element)
			}
		}
		
		svg.elements.append(element)
	}
}
