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
	
	fileprivate func parseRect(attributes: [String : String]) throws {
		var bounds = CGRect.zero
		var style = SVGStyle()
		for (name, value) in attributes {
			switch name {
			case "x":
				bounds.origin.x = try CGFloat.parse(value)
			case "y":
				bounds.origin.y = try CGFloat.parse(value)
			case "width":
				bounds.size.width = try CGFloat.parse(value)
			case "height":
				bounds.size.height = try CGFloat.parse(value)
			case "style":
				style = try SVGStyle(definition: value)
			default:
				print("unrecognized attribute \(name)=\(value) on rect")
			}
		}
		
		let path = CGPath(rect: bounds, transform: nil)
		let element = SVGElement(path: path, style: style)
		
		svg.elements.append(element)
	}
}
