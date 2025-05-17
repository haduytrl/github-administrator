import UIKit
import Kingfisher

public extension UIImageView {
  func setCacheImage(url: URL?) {
    self.kf.setImage(with: url, options: [
        .scaleFactor(UIScreen.main.scale),
        .transition(.fade(0.2)),
        .cacheOriginalImage,
        .memoryCacheExpiration(.seconds(45))
    ])
  }
}
