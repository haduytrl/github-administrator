import UIKit

public protocol DiffableCollectionProvider {
    associatedtype Section: Hashable
    associatedtype Item: Hashable
    associatedtype CellType: UICollectionViewCell
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias CellRegistration = UICollectionView.CellRegistration<CellType, Item>
    
    func makeDataSource(for collectionView: UICollectionView) -> DataSource
    func createLayout() -> UICollectionViewLayout
}
