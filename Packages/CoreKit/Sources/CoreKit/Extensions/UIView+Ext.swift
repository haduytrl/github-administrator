import UIKit

public extension UIView {
    func appAddSubviews(views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}
