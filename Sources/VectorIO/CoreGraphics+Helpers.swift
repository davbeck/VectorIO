import Foundation
import CoreGraphics


func + (_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
	return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}
