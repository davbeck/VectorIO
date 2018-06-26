import Foundation
import CoreGraphics


private let numbersWithDots = try! NSRegularExpression(pattern: "((\\d?\\.\\d+(?:e[+-]?\\d+)?)((?:\\.\\d+(?:e[+-]?\\d+)?)+))+", options: [.caseInsensitive])
private let hyphen = try! NSRegularExpression(pattern: "([^e])\\-", options: [.caseInsensitive])

private let commands = try! NSRegularExpression(pattern: "([MLQTCSAZVH])([^MLQTCSAZVH]*)", options: [.caseInsensitive])


public class SVGPathDefinitionParser {
	public struct ParseError: Swift.Error {
		public var definition: String
		public var command: String
		public var arguments: Array<String>
		
		public enum Cause {
			case wrongNumberOfArguments(expected: Int)
		}
		
		public var cause: Cause?
		
		init(definition: String, command: String, arguments: Array<String>, cause: Cause? = nil) {
			self.definition = definition
			self.command = command
			self.arguments = arguments
			self.cause = cause
		}
	}
	
	
	public let string: String
	
	public init(_ string: String) {
		self.string = string
	}
	
	
	private var currentPoint: CGPoint = .zero
	private var currentControl: CGPoint = .zero
	private var reflexionControl: CGPoint {
		return CGPoint(
			x: currentPoint.x + (currentPoint.x - currentControl.x),
			y: currentPoint.y + (currentPoint.y - currentControl.y)
		)
	}
	
	private var command: Substring = ""
	private var isRelative: Bool {
		return command.lowercased() == command
	}
	
	private var adjustment: CGPoint {
		return isRelative ? currentPoint : .zero
	}
	
	public func parse() throws -> Array<SVGPath.Definition> {
		let value = self.string
		var definitions: [SVGPath.Definition] = []
		for result in commands.matches(in: value) {
			guard
				let commandRange = Range(result.range(at: 1), in: value),
				let valuesRange = Range(result.range(at: 2), in: value)
			else { continue }
			command = value[commandRange]
			let arguments = parse(arguments: String(value[valuesRange]))
			
			switch command.uppercased() {
			case "M":
				for arguments in try self.iterate(arguments: arguments, by: 2) {
					let end = try CGPoint(
						x: CGFloat.parse(arguments[arguments.startIndex + 0]),
						y: CGFloat.parse(arguments[arguments.startIndex + 1])
					) + adjustment
					definitions.append(.moveTo(end))
					currentPoint = end
					currentControl = end
				}
			case "L":
				for arguments in try self.iterate(arguments: arguments, by: 2) {
					let end = try CGPoint(
						x: CGFloat.parse(arguments[arguments.startIndex + 0]),
						y: CGFloat.parse(arguments[arguments.startIndex + 1])
					) + adjustment
					definitions.append(.lineTo(end))
					currentPoint = end
					currentControl = end
				}
			case "V":
				for arguments in try self.iterate(arguments: arguments, by: 1) {
					let end = try CGPoint(
						x: currentPoint.x,
						y: CGFloat.parse(arguments[arguments.startIndex + 0]) + adjustment.y
					)
					definitions.append(.lineTo(end))
					currentPoint = end
					currentControl = end
				}
			case "H":
				for arguments in try self.iterate(arguments: arguments, by: 1) {
					let end = try CGPoint(
						x: CGFloat.parse(arguments[arguments.startIndex + 0]) + adjustment.x,
						y: currentPoint.y
					)
					definitions.append(.lineTo(end))
					currentPoint = end
					currentControl = end
				}
			case "Q":
				for arguments in try self.iterate(arguments: arguments, by: 4) {
					let control = try CGPoint(
						x: CGFloat.parse(arguments[arguments.startIndex + 0]),
						y: CGFloat.parse(arguments[arguments.startIndex + 1])
					) + adjustment
					let end = try CGPoint(
						x: CGFloat.parse(arguments[arguments.startIndex + 2]),
						y: CGFloat.parse(arguments[arguments.startIndex + 3])
					) + adjustment
					definitions.append(.quadraticBezierCurve(control: control, end: end))
					currentPoint = end
					currentControl = control
				}
			case "T":
				for arguments in try self.iterate(arguments: arguments, by: 2) {
					let control = reflexionControl
					let end = try CGPoint(
						x: CGFloat.parse(arguments[arguments.startIndex + 0]),
						y: CGFloat.parse(arguments[arguments.startIndex + 1])
					) + adjustment
					definitions.append(.quadraticBezierCurve(control: control, end: end))
					currentPoint = end
					currentControl = control
				}
			case "C":
				for arguments in try self.iterate(arguments: arguments, by: 6) {
					let controlStart = try CGPoint(
						x: CGFloat.parse(arguments[arguments.startIndex + 0]),
						y: CGFloat.parse(arguments[arguments.startIndex + 1])
					) + adjustment
					let controlEnd = try CGPoint(
						x: CGFloat.parse(arguments[arguments.startIndex + 2]),
						y: CGFloat.parse(arguments[arguments.startIndex + 3])
					) + adjustment
					let end = try CGPoint(
						x: CGFloat.parse(arguments[arguments.startIndex + 4]),
						y: CGFloat.parse(arguments[arguments.startIndex + 5])
					) + adjustment
					definitions.append(.cubicBezierCurve(CubicBezierCurve(controlStart: controlStart, controlEnd: controlEnd, end: end)))
					currentPoint = end
					currentControl = controlEnd
				}
			case "S":
				for arguments in try self.iterate(arguments: arguments, by: 4) {
					let controlStart = reflexionControl
					let controlEnd = try CGPoint(
						x: CGFloat.parse(arguments[arguments.startIndex + 0]),
						y: CGFloat.parse(arguments[arguments.startIndex + 1])
					) + adjustment
					let end = try CGPoint(
						x: CGFloat.parse(arguments[arguments.startIndex + 2]),
						y: CGFloat.parse(arguments[arguments.startIndex + 3])
					) + adjustment
					definitions.append(.cubicBezierCurve(CubicBezierCurve(controlStart: controlStart, controlEnd: controlEnd, end: end)))
					currentPoint = end
					currentControl = controlEnd
				}
			case "A":
				for arguments in try self.iterate(arguments: arguments, by: 7) {
					let radius = try CGSize(
						width: CGFloat.parse(arguments[arguments.startIndex + 0]),
						height: CGFloat.parse(arguments[arguments.startIndex + 1])
					)
					let angle = try CGFloat.parse(arguments[arguments.startIndex + 2])
					let isLargeArc = Int(arguments[arguments.startIndex + 3]) == 1
					let isSweep = Int(arguments[arguments.startIndex + 4]) == 1
					let end = try CGPoint(
						x: CGFloat.parse(arguments[arguments.startIndex + 5]),
						y: CGFloat.parse(arguments[arguments.startIndex + 6])
					) + adjustment
					definitions += arcToBezier(start: currentPoint, end: end, radius: radius, xAxisRotation: angle, largeArcFlag: isLargeArc, sweepFlag: isSweep)
						.map({ .cubicBezierCurve($0) })
					currentPoint = end
					currentControl = end
				}
			case "Z":
				definitions.append(.closePath)
			default:
				throw ParseError(definition: value, command: String(command), arguments: arguments)
			}
		}
		
		return definitions
	}
	
	private func parse(arguments: String) -> Array<String> {
		return arguments
			.replacingOccurrences(of: numbersWithDots, with: { matches in
				return String(matches[2]) + matches[3].replacingOccurrences(of: ".", with: " .")
			})
			.replacingOccurrences(of: hyphen, with: "$1 -")
			.components(separatedBy: .svgValueSeparators)
			.filter({ !$0.isEmpty })
	}
	
	private func iterate(arguments: Array<String>, by expected: Int) throws -> [ArraySlice<String>] {
		guard arguments.count % expected == 0 else { throw ParseError(definition: string, command: String(command), arguments: arguments, cause: .wrongNumberOfArguments(expected: expected)) }
		return arguments.stride(by: expected)
	}
}
