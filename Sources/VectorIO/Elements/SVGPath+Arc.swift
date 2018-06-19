// adapted from https://github.com/colinmeinke/svg-arc-to-cubic-bezier
import Foundation
import CoreGraphics



extension BinaryFloatingPoint {
	fileprivate static var tau: Self {
		return .pi * 2
	}
}

private func mapToEllipse(_ point: CGPoint, radius: CGSize, cosphi: CGFloat, sinphi: CGFloat, center: CGPoint) -> CGPoint {
	var point = point
	point.x *= radius.width
	point.y *= radius.height
	
	let xp = cosphi * point.x - sinphi * point.y
	let yp = sinphi * point.x + cosphi * point.y
	
	return CGPoint(x: xp + center.x, y: yp + center.y)
}

private func approxUnitArc(ang1: CGFloat, ang2: CGFloat) -> CubicBezierCurve {
	// See http://spencermortensen.com/articles/bezier-circle/ for the derivation
	// of this letant.
	let c: CGFloat = 0.551915024494
	
	let x1 = cos(ang1)
	let y1 = sin(ang1)
	let x2 = cos(ang1 + ang2)
	let y2 = sin(ang1 + ang2)
	
	return CubicBezierCurve(
		controlStart: CGPoint(x: x1 - y1 * c, y: y1 + x1 * c),
		controlEnd: CGPoint(x: x2 + y2 * c, y: y2 - x2 * c),
		end: CGPoint(x: x2, y: y2)
	)
}

private func vectorAngle(u: CGPoint, v: CGPoint) -> CGFloat {
	let sign = (u.x * v.y - u.y * v.x < 0) ? -1 : 1
	let umag = (u.x * u.x + u.y * u.y).squareRoot()
	let vmag = (u.x * u.x + u.y * u.y).squareRoot()
	let dot = u.x * v.x + u.y * v.y
	
	var div = dot / (umag * vmag)
	
	if div > 1 {
		div = 1
	}
	
	if div < -1 {
		div = -1
	}
	
	return CGFloat(sign) * acos(div)
}

private func getArcCenter(
	start: CGPoint,
	end: CGPoint,
	radius: CGSize,
	largeArcFlag: Bool,
	sweepFlag: Bool,
	sinphi: CGFloat,
	cosphi: CGFloat,
	pxp: CGFloat,
	pyp: CGFloat
) -> (center: CGPoint, ang1: CGFloat, ang2: CGFloat) {
	let rxsq = pow(radius.width, 2)
	let rysq = pow(radius.height, 2)
	let pxpsq = pow(pxp, 2)
	let pypsq = pow(pyp, 2)
	
	var radicant = (rxsq * rysq) - (rxsq * pypsq) - (rysq * pxpsq)
	
	if radicant < 0 {
		radicant = 0
	}
	
	radicant /= (rxsq * pypsq) + (rysq * pxpsq)
	radicant = radicant.squareRoot() * (largeArcFlag == sweepFlag ? -1 : 1)
	
	let centerxp = radicant * radius.width / radius.height * pyp
	let centeryp = radicant * -radius.height / radius.width * pxp
	
	let center = CGPoint(
		x: cosphi * centerxp - sinphi * centeryp + (start.x + end.x) / 2,
		y: sinphi * centerxp + cosphi * centeryp + (start.y + end.y) / 2
	)
	
	let vx1 = (pxp - centerxp) / radius.width
	let vy1 = (pyp - centeryp) / radius.height
	let vx2 = (-pxp - centerxp) / radius.width
	let vy2 = (-pyp - centeryp) / radius.height
	
	let ang1 = vectorAngle(u: CGPoint(x: 1, y: 0), v: CGPoint(x: vx1, y: vy1))
	var ang2 = vectorAngle(u: CGPoint(x: vx1, y: vy1), v: CGPoint(x: vx2, y: vy2))
	
	if !sweepFlag && ang2 > 0 {
		ang2 -= CGFloat.tau
	}
	
	if sweepFlag && ang2 < 0 {
		ang2 += CGFloat.tau
	}
	
	return (center, ang1, ang2)
}

internal func arcToBezier(
	start: CGPoint,
	end: CGPoint,
	radius: CGSize,
	xAxisRotation: CGFloat = 0,
	largeArcFlag: Bool = false,
	sweepFlag: Bool = false
) -> [CubicBezierCurve] {
	var radius = radius
	
	if radius.width == 0 || radius.height == 0 {
		return []
	}
	
	let sinphi = sin(xAxisRotation * .tau / 360)
	let cosphi = cos(xAxisRotation * .tau / 360)
	
	let pxp = cosphi * (start.x - end.x) / 2 + sinphi * (start.y - end.y) / 2
	let pyp = -sinphi * (start.x - end.x) / 2 + cosphi * (start.y - end.y) / 2
	
	if pxp == 0 && pyp == 0 {
		return []
	}
	
	radius.width = abs(radius.width)
	radius.height = abs(radius.height)
	
	let lambda =
		pow(pxp, 2) / pow(radius.width, 2) +
		pow(pyp, 2) / pow(radius.height, 2)
	
	if lambda > 1 {
		radius.width *= lambda.squareRoot()
		radius.height *= lambda.squareRoot()
	}
	
	var (center, ang1, ang2) = getArcCenter(
		start: start,
		end: end,
		radius: radius,
		largeArcFlag: largeArcFlag,
		sweepFlag: sweepFlag,
		sinphi: sinphi,
		cosphi: cosphi,
		pxp: pxp,
		pyp: pyp
	)
	
	let segments = Int(max(ceil(abs(ang2) / (.tau / 4)), 1))
	
	ang2 /= CGFloat(segments)
	
	let curves: Array<CubicBezierCurve> = (0..<segments).map({ i in
		ang1 += ang2
		return approxUnitArc(ang1: ang1, ang2: ang2)
	})
	
	return curves.map({ curve in
		let control1 = mapToEllipse(curve.controlStart, radius: radius, cosphi: cosphi, sinphi: sinphi, center: center)
		let control2 = mapToEllipse(curve.controlEnd, radius: radius, cosphi: cosphi, sinphi: sinphi, center: center)
		let end = mapToEllipse(curve.end, radius: radius, cosphi: cosphi, sinphi: sinphi, center: center)
		
		return CubicBezierCurve(controlStart: control1, controlEnd: control2, end: end)
	})
}
