import UIKit

extension UIImage {
	private static let tagCache = NSCache<AnyObject, UIImage>()
	private static let tagRenderer = UIGraphicsImageRenderer(size: CGSize(width: 400, height: 110))
	
	static func tag(tintColor: UIColor? = nil) -> UIImage {
		let key: AnyObject = tintColor ?? NSNull()
		if let image = tagCache.object(forKey: key) {
			return image
		}
		
		let image = tagRenderer.image { context in
		}
		tagCache.setObject(image, forKey: key)
		
		return image
	}
}
