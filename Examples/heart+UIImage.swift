import UIKit

extension UIImage {
	private static let heartCache = NSCache<AnyObject, UIImage>()
	private static let heartRenderer = UIGraphicsImageRenderer(size: CGSize(width: 400, height: 110))
	
	static func heart(tintColor: UIColor? = nil) -> UIImage {
		let key: AnyObject = tintColor ?? NSNull()
		if let image = heartCache.object(forKey: key) {
			return image
		}
		
		let image = heartRenderer.image { context in
			do {
				let path = UIBezierPath()
				path.move(to: CGPoint(x: 10.00, y: 30.00))
				path.addCurve(to: CGPoint(x: 50.00, y: 30.00), controlPoint1: CGPoint(x: 41.04, y: 10.00), controlPoint2: CGPoint(x: 50.00, y: 18.96))
				path.addCurve(to: CGPoint(x: 30.00, y: 50.00), controlPoint1: CGPoint(x: 50.00, y: 41.04), controlPoint2: CGPoint(x: 41.04, y: 50.00))
				path.addCurve(to: CGPoint(x: 90.00, y: 30.00), controlPoint1: CGPoint(x: 81.04, y: 10.00), controlPoint2: CGPoint(x: 90.00, y: 18.96))
				path.addCurve(to: CGPoint(x: 70.00, y: 50.00), controlPoint1: CGPoint(x: 90.00, y: 41.04), controlPoint2: CGPoint(x: 81.04, y: 50.00))
				path.addQuadCurve(to: CGPoint(x: 50.00, y: 90.00), controlPoint: CGPoint(x: 90.00, y: 60.00))
				path.addQuadCurve(to: CGPoint(x: 10.00, y: 30.00), controlPoint: CGPoint(x: 10.00, y: 60.00))
				path.close()
				path.lineWidth = 1.0
				if let tintColor = tintColor {
					tintColor.set()
				} else {
					UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00).setStroke()
				}
				path.stroke()
			}
		}
		heartCache.setObject(image, forKey: key)
		
		return image
	}
}
