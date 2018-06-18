import Foundation
import CoreGraphics


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
		case cubicBezierCurve(controlStart: CGPoint, controlEnd: CGPoint, end: CGPoint)
		case arc(radius: CGPoint, angle: CGFloat, isLargeArc: Bool, isSweep: Bool, end: CGPoint)
		case closePath
		
		
		static func parse(_ value: String) throws -> [Definition] {
			var definitions: [SVGPath.Definition] = []
			
			var separatorCharacters = CharacterSet.whitespacesAndNewlines
			separatorCharacters.insert(",")
			
			var currentPoint: CGPoint = .zero
			var currentControl: CGPoint = .zero
			var reflexionControl: CGPoint {
				return CGPoint(
					x: currentPoint.x + (currentPoint.x - currentControl.x),
					y: currentPoint.y + (currentPoint.y - currentControl.y)
				)
			}
			
			var arguments = ArraySlice(value.components(separatedBy: separatorCharacters))
			while var command = arguments.first {
				arguments.removeFirst()
				guard !command.isEmpty else { continue }
				
				if command.count > 1 {
					arguments.insert(String(command.dropFirst()), at: arguments.startIndex)
					command = String(command.first!)
				}
				
				switch command.uppercased() {
				case "M":
					let end = try CGPoint(
						x: CGFloat.parse(arguments.removeFirst()),
						y: CGFloat.parse(arguments.removeFirst())
					)
					definitions.append(.moveTo(end))
					currentPoint = end
					currentControl = end
				case "L":
					let end = try CGPoint(
						x: CGFloat.parse(arguments.removeFirst()),
						y: CGFloat.parse(arguments.removeFirst())
					)
					definitions.append(.lineTo(end))
					currentPoint = end
					currentControl = end
				case "Q":
					let control = try CGPoint(
						x: CGFloat.parse(arguments.removeFirst()),
						y: CGFloat.parse(arguments.removeFirst())
					)
					let end = try CGPoint(
						x: CGFloat.parse(arguments.removeFirst()),
						y: CGFloat.parse(arguments.removeFirst())
					)
					definitions.append(.quadraticBezierCurve(control: control, end: end))
					currentPoint = end
					currentControl = control
				case "T":
					let control = reflexionControl
					let end = try CGPoint(
						x: CGFloat.parse(arguments.removeFirst()),
						y: CGFloat.parse(arguments.removeFirst())
					)
					definitions.append(.quadraticBezierCurve(control: control, end: end))
					currentPoint = end
					currentControl = control
				case "C":
					let controlStart = try CGPoint(
						x: CGFloat.parse(arguments.removeFirst()),
						y: CGFloat.parse(arguments.removeFirst())
					)
					let controlEnd = try CGPoint(
						x: CGFloat.parse(arguments.removeFirst()),
						y: CGFloat.parse(arguments.removeFirst())
					)
					let end = try CGPoint(
						x: CGFloat.parse(arguments.removeFirst()),
						y: CGFloat.parse(arguments.removeFirst())
					)
					definitions.append(.cubicBezierCurve(controlStart: controlStart, controlEnd: controlEnd, end: end))
					currentPoint = end
					currentControl = controlEnd
				case "S":
					let controlStart = reflexionControl
					let controlEnd = try CGPoint(
						x: CGFloat.parse(arguments.removeFirst()),
						y: CGFloat.parse(arguments.removeFirst())
					)
					let end = try CGPoint(
						x: CGFloat.parse(arguments.removeFirst()),
						y: CGFloat.parse(arguments.removeFirst())
					)
					definitions.append(.cubicBezierCurve(controlStart: controlStart, controlEnd: controlEnd, end: end))
					currentPoint = end
					currentControl = controlEnd
				case "A":
					let rx = try CGFloat.parse(arguments.removeFirst())
					let ry = try CGFloat.parse(arguments.removeFirst())
					let angle = try CGFloat.parse(arguments.removeFirst())
					let isLargeArc = Int(arguments.removeFirst()) == 1
					let isSweep = Int(arguments.removeFirst()) == 1
					let end = try CGPoint(
						x: CGFloat.parse(arguments.removeFirst()),
						y: CGFloat.parse(arguments.removeFirst())
					)
					definitions.append(.arc(radius: CGPoint(x: rx, y: ry), angle: angle, isLargeArc: isLargeArc, isSweep: isSweep, end: end))
					currentPoint = end
					currentControl = end
				case "Z":
					definitions.append(.closePath)
				default:
					throw ParseError(definition: value, command: command)
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