import UIKit

extension UIImage {
    private static let noteTagCache = NSCache<AnyObject, UIImage>()

    static func noteTag(tintColor: UIColor? = nil) -> UIImage {
        let key: AnyObject = tintColor ?? NSNull()
        if let image = noteTagCache.object(forKey: key) {
            return image
        }

        private static let renderer = UIGraphicsImageRenderer(size: CGPoint(width: 14.00, height: 14.00))
        let image = renderer.image { context in
			do {
				do {
				let path = UIBezierPath()
			path.move(to: CGPoint(x: 6.23, y: 1.23))
			path.addLine(to: CGPoint(x: 12.95, y: 7.95))
			path.addCurve(to: CGPoint(x: 12.95, y: 9.05), controlPoint1: CGPoint(x: 13.25, y: 8.25), controlPoint2: CGPoint(x: 13.25, y: 8.75))
			path.addLine(to: CGPoint(x: 9.05, y: 12.95))
			path.addCurve(to: CGPoint(x: 7.95, y: 12.95), controlPoint1: CGPoint(x: 8.75, y: 13.25), controlPoint2: CGPoint(x: 8.25, y: 13.25))
			path.addLine(to: CGPoint(x: 1.23, y: 6.23))
			path.addCurve(to: CGPoint(x: 1.00, y: 5.68), controlPoint1: CGPoint(x: 1.08, y: 6.08), controlPoint2: CGPoint(x: 1.00, y: 5.88))
			path.addLine(to: CGPoint(x: 1.00, y: 1.78))
			path.addCurve(to: CGPoint(x: 1.78, y: 1.00), controlPoint1: CGPoint(x: 1.00, y: 1.35), controlPoint2: CGPoint(x: 1.35, y: 1.00))
			path.addLine(to: CGPoint(x: 5.68, y: 1.00))
			path.addCurve(to: CGPoint(x: 6.23, y: 1.23), controlPoint1: CGPoint(x: 5.88, y: 1.00), controlPoint2: CGPoint(x: 6.08, y: 1.08))
			path.close()
			path.move(to: CGPoint(x: 3.50, y: 4.67))
			path.addCurve(to: CGPoint(x: 4.67, y: 3.50), controlPoint1: CGPoint(x: 4.14, y: 4.67), controlPoint2: CGPoint(x: 4.67, y: 4.14))
			path.addCurve(to: CGPoint(x: 3.50, y: 2.33), controlPoint1: CGPoint(x: 4.67, y: 2.86), controlPoint2: CGPoint(x: 4.14, y: 2.33))
			path.addCurve(to: CGPoint(x: 2.33, y: 3.50), controlPoint1: CGPoint(x: 2.86, y: 2.33), controlPoint2: CGPoint(x: 2.33, y: 2.86))
			path.addCurve(to: CGPoint(x: 3.50, y: 4.67), controlPoint1: CGPoint(x: 2.33, y: 4.14), controlPoint2: CGPoint(x: 2.86, y: 4.67))
			path.close()
			if let tintColor = tintColor {
				tintColor.set()
			} else {
				UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.00).setFill()
			}
			path.fill()
			
			}
			}
        }
        noteTagCache.setObject(image, forKey: key)
        
        return image
    }
}