import CoreKit
import UIKit

extension UserListViewController {
    func makeCollectionView() -> UICollectionView {
        let v = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        v.backgroundColor = .clear
        v.delegate = self
        return v
    }
    
    func makeActivityIndicator() -> UIActivityIndicatorView {
        let v = UIActivityIndicatorView(style: .medium)
        v.hidesWhenStopped = true
        v.startAnimating()
        return v
    }
}
