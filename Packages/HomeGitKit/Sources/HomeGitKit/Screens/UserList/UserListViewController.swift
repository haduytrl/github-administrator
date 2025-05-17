import UIKit
import Combine
import CoreKit

class UserListViewController: BaseViewController<UserListViewModel> {
    // MARK: Properties
    
    private(set) lazy var dataSource: DataSource = makeDataSource(for: collectionView)
    
    // MARK: Declare UI
    
    private lazy var activityIndicator  = makeActivityIndicator()
    private lazy var collectionView     = makeCollectionView()
    
    // MARK: Life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.firstLoadData()
    }
    
    // MARK: Setup
    
    override func setupUI() {
        super.setupUI()
        
        title = "Github Users"
        
        view.appAddSubviews(views: activityIndicator, collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func setupBindViewModel() {
        cancellables = []
        
        viewModel.$users
            .dropFirst()
            .map { [weak self] users -> Snapshot in
                guard let self else { return .init() }
                
                // Mapping users to snapshot
                return !users.isEmpty ? makeSnapshotOfUsers(users)
                                      : makeSnapshotOfEmpty()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] snapshot in
                guard let self else { return }
                activityIndicator.removeFromSuperview()
                dataSource.apply(snapshot, animatingDifferences: true)
                
                if snapshot.numberOfItems < 3 {
                    collectionView.isScrollEnabled = false
                }
            }.store(in: &cancellables)
        
        viewModel.$errorMessage
            .dropFirst()
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .sink { [weak self] message in
                self?.showErrorAlert(message: message)
            }.store(in: &cancellables)
    }
}

// MARK: - Collection configure

extension UserListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let triggerRow = max(0, dataSource.snapshot().numberOfItems - 2)
        guard indexPath.row == triggerRow else { return }
        viewModel.performUpdate()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource.snapshot().itemIdentifiers[indexPath.row]
        guard case let .user(data) = item else { return }
        
        viewModel.handleUserItemTapped(for: data)
    }
}
