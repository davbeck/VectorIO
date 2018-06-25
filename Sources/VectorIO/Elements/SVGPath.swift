import Foundation
import CoreGraphics


public struct CubicBezierCurve: Equatable {
	public var controlStart: CGPoint
	public var controlEnd: CGPoint
	public var end: CGPoint
	
	public init(controlStart: CGPoint, controlEnd: CGPoint, end: CGPoint) {
		self.controlStart = controlStart
		self.controlEnd = controlEnd
		self.end = end
	}
}


public struct SVGPath: SVGElement {
	public static let elementName: String = "path"
	
	public enum Definition: Equatable {
		public struct ParseError: Swift.Error {
			var definition: String
			var command: String
		}
		
		case moveTo(CGPoint)
		case lineTo(CGPoint)
		case quadraticBezierCurve(control: CGPoint, end: CGPoint)
		case cubicBezierCurve(CubicBezierCurve)
		case closePath
		
		public static func cubicBezierCurve(controlStart: CGPoint, controlEnd: CGPoint, end: CGPoint) -> Definition {
			return .cubicBezierCurve(CubicBezierCurve(controlStart: controlStart, controlEnd: controlEnd, end: end))
		}
		
		
		private static let numbersWithDots = try! NSRegularExpression(pattern: "((\\d?\\.\\d+(?:e[+-]?\\d+)?)((?:\\.\\d+(?:e[+-]?\\d+)?)+))+", options: [.caseInsensitive])
		private static let hyphen = try! NSRegularExpression(pattern: "([^e])\\-", options: [.caseInsensitive])
		private static func normalize(arguments: String) -> Array<String> {
			return arguments
				.replacingOccurrences(of: numbersWithDots, with: { matches in
					return String(matches[2]) + matches[3].replacingOccurrences(of: ".", with: " .")
				})
				.replacingOccurrences(of: hyphen, with: "$1 -")
				.components(separatedBy: .svgValueSeparators)
				.filter({ !$0.isEmpty })
		}
		
		private static let commands = try! NSRegularExpression(pattern: "([MLQTCSAZVH])([^MLQTCSAZVH]*)", options: [.caseInsensitive])
		
		static func parse(_ value: String) throws -> [Definition] {
			var definitions: [SVGPath.Definition] = []
			
			var currentPoint: CGPoint = .zero
			var currentControl: CGPoint = .zero
			var reflexionControl: CGPoint {
				return CGPoint(
					x: currentPoint.x + (currentPoint.x - currentControl.x),
					y: currentPoint.y + (currentPoint.y - currentControl.y)
				)
			}
			for result in commands.matches(in: value) {
				guard
					let commandRange = Range(result.range(at: 1), in: value),
					let valuesRange = Range(result.range(at: 2), in: value)
				else { continue }
				let command = value[commandRange]
				let arguments = normalize(arguments: String(value[valuesRange]))
				let isRelative = command.lowercased() == command
				let adjustment: CGPoint = isRelative ? currentPoint : .zero
				
				switch command.uppercased() {
				case "M":
					let end = try CGPoint(
						x: CGFloat.parse(arguments[0]),
						y: CGFloat.parse(arguments[1])
					) + adjustment
					definitions.append(.moveTo(end))
					currentPoint = end
					currentControl = end
				case "L":
					let end = try CGPoint(
						x: CGFloat.parse(arguments[0]),
						y: CGFloat.parse(arguments[1])
					) + adjustment
					definitions.append(.lineTo(end))
					currentPoint = end
					currentControl = end
				case "V":
					let end = try CGPoint(
						x: currentPoint.x,
						y: CGFloat.parse(arguments[0]) + adjustment.y
					)
					definitions.append(.lineTo(end))
					currentPoint = end
					currentControl = end
				case "H":
					let end = try CGPoint(
						x: CGFloat.parse(arguments[0]) + adjustment.x,
						y: currentPoint.y
					)
					definitions.append(.lineTo(end))
					currentPoint = end
					currentControl = end
				case "Q":
					let control = try CGPoint(
						x: CGFloat.parse(arguments[0]),
						y: CGFloat.parse(arguments[1])
					) + adjustment
					let end = try CGPoint(
						x: CGFloat.parse(arguments[2]),
						y: CGFloat.parse(arguments[3])
					) + adjustment
					definitions.append(.quadraticBezierCurve(control: control, end: end))
					currentPoint = end
					currentControl = control
				case "T":
					let control = reflexionControl
					let end = try CGPoint(
						x: CGFloat.parse(arguments[0]),
						y: CGFloat.parse(arguments[1])
					) + adjustment
					definitions.append(.quadraticBezierCurve(control: control, end: end))
					currentPoint = end
					currentControl = control
				case "C":
					let controlStart = try CGPoint(
						x: CGFloat.parse(arguments[0]),
						y: CGFloat.parse(arguments[1])
					) + adjustment
					let controlEnd = try CGPoint(
						x: CGFloat.parse(arguments[2]),
						y: CGFloat.parse(arguments[3])
					) + adjustment
					let end = try CGPoint(
						x: CGFloat.parse(arguments[4]),
						y: CGFloat.parse(arguments[5])
					) + adjustment
					definitions.append(.cubicBezierCurve(CubicBezierCurve(controlStart: controlStart, controlEnd: controlEnd, end: end)))
					currentPoint = end
					currentControl = controlEnd
				case "S":
					let controlStart = reflexionControl
					let controlEnd = try CGPoint(
						x: CGFloat.parse(arguments[0]),
						y: CGFloat.parse(arguments[1])
					) + adjustment
					let end = try CGPoint(
						x: CGFloat.parse(arguments[2]),
						y: CGFloat.parse(arguments[3])
					) + adjustment
					definitions.append(.cubicBezierCurve(CubicBezierCurve(controlStart: controlStart, controlEnd: controlEnd, end: end)))
					currentPoint = end
					currentControl = controlEnd
				case "A":
					let radius = try CGSize(
						width: CGFloat.parse(arguments[0]),
						height: CGFloat.parse(arguments[1])
					)
					let angle = try CGFloat.parse(arguments[2])
					let isLargeArc = Int(arguments[3]) == 1
					let isSweep = Int(arguments[4]) == 1
					let end = try CGPoint(
						x: CGFloat.parse(arguments[5]),
						y: CGFloat.parse(arguments[6])
					) + adjustment
					definitions += arcToBezier(start: currentPoint, end: end, radius: radius, xAxisRotation: angle, largeArcFlag: isLargeArc, sweepFlag: isSweep)
						.map({ .cubicBezierCurve($0) })
					currentPoint = end
					currentControl = end
				case "Z":
					definitions.append(.closePath)
				default:
					throw ParseError(definition: value, command: String(command))
				}
			}
			
			return definitions
		}
	}
	
	public var definitions: [Definition]
	public var style: CSSStyle
	
	public init(definitions: [Definition] = [], style: CSSStyle = CSSStyle()) {
		self.definitions = definitions
		self.style = style
	}
}
