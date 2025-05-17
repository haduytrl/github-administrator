import CoreKit
import UIKit
import GlobalEntities

// MARK: - Builder
extension UserListViewController: DiffableCollectionProvider {
    typealias VM = UserListViewModel
    typealias Section = VM.Section
    typealias Item = VM.Item
    typealias CellType = UICollectionViewCell
    
    // Init data source
    func makeDataSource(for collectionView: UICollectionView) -> DataSource {
        let userCell = makeItemCellRegistration()
        let emptyCell = makeEmptyCellRegistration()
        
        return .init(collectionView: collectionView) { collection, index, item in
            var cellRegistration: CellRegistration
            
            switch item {
            case .user:
                cellRegistration = userCell
            case .empty:
                cellRegistration = emptyCell
            }
            
            return collection.dequeueConfiguredReusableCell(using: cellRegistration, for: index, item: item)
        }
    }
    
    // Create list layout
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            
            let section = dataSource.snapshot().sectionIdentifiers[sectionIndex]
            let items = dataSource.snapshot().itemIdentifiers(inSection: section)
            
            // check condition of items
            guard !items.isEmpty else { return nil }
            return makeSectionLayout(estimatedHeight: section.estimatedItemHeight)
        }
    }
    
    // Making users snapshot
    func makeSnapshotOfUsers(_ datas: [UserModel]) -> Snapshot {
        var snapshot = Snapshot()
        let items = datas.map { VM.Item.user($0) } // Map to ViewModel Items
        
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        
        return snapshot
    }
    
    // Making empty snapshot
    func makeSnapshotOfEmpty() -> Snapshot {
        var snapshot = Snapshot()
        let items: [VM.Item] = [.empty]
        
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        
        return snapshot
    }
}

// MARK: Private Method
private extension UserListViewController {
    // Create section layout
    func makeSectionLayout(estimatedHeight: CGFloat) -> NSCollectionLayoutSection {
        /// Create item with itemSize
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        /// Create group with item & groupSize
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(estimatedHeight))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        /// Create section layout
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: .getSpacing(.medium),
            leading: .getSpacing(.mediumLarge),
            bottom: .getSpacing(.large),
            trailing: .getSpacing(.mediumLarge)
        )
        section.interGroupSpacing = .getSpacing(.xmedium)

        return section
    }
    
    // Create Item registration
    /// User cell
    func makeItemCellRegistration() -> CellRegistration {
        return .init { cell, _, item in
            guard case let .user(data) = item else { return }
            let userCell = UserContentConfig(user: data)
            cell.contentConfiguration = userCell
        }
    }
    
    /// Empty cell
    func makeEmptyCellRegistration() -> CellRegistration {
        return .init { cell, _, item in
            guard case .empty = item else { return }
            let emptyCell = EmptyContentConfig()
            cell.contentConfiguration = emptyCell
        }
    }
}
