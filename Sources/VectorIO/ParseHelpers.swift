import Foundation


public enum ParseError: Swift.Error {
	case invalidNumber(String)
	case invalidColor(String)
}


extension CGFloat {
	public static func parse<S: StringProtocol>(_ value: S) throws -> CGFloat {
		guard let double = Double(value) else { throw ParseError.invalidNumber(String(value)) }
		return CGFloat(double)
	}
}

extension CGColor {
	public static func parse<S: StringProtocol>(_ cssColor: S) throws -> CGColor {
		var error: ParseError {
			return ParseError.invalidColor(String(cssColor))
		}
		
		if cssColor.hasPrefix("#") {
			let hexString = cssColor.dropFirst()
			switch (hexString.count) {
			case 3:
				guard let hex = UInt16(hexString, radix: 16) else { throw error }
				let divisor = CGFloat(15)
				let red     = CGFloat((hex & 0xF00) >> 8) / divisor
				let green   = CGFloat((hex & 0x0F0) >> 4) / divisor
				let blue    = CGFloat( hex & 0x00F      ) / divisor
				return CGColor(red: red, green: green, blue: blue, alpha: 1)
			case 6:
				guard let hex = UInt32(hexString, radix: 16) else { throw error }
				let divisor = CGFloat(255)
				let red     = CGFloat((hex & 0xFF0000) >> 16) / divisor
				let green   = CGFloat((hex & 0x00FF00) >>  8) / divisor
				let blue    = CGFloat( hex & 0x0000FF       ) / divisor
				return CGColor(red: red, green: green, blue: blue, alpha: 1)
			default:
				throw error
			}
		} else if cssColor.hasPrefix("rgb(") {
			guard
				let open = cssColor.firstIndex(of: "("),
				let close = cssColor.lastIndex(of: ")")
				else { throw error }
			let start = cssColor.index(after: open)
			let end = cssColor.index(before: close)
			let components = cssColor[start...end]
				.split(separator: ",")
				.compactMap({ Int($0) })
			guard components.count == 3 else { throw error }
			
			return CGColor(
				red: CGFloat(components[0]),
				green: CGFloat(components[1]),
				blue: CGFloat(components[2]),
				alpha: 1
			)
		} else {
			throw error
		}
	}
}
