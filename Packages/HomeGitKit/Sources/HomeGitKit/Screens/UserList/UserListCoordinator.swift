import CoreKit
import DataKit
import GlobalUsecase
import DomainRepositories
import UIKit
import Combine
import NetworkProvider

public final class UserListCoordinator: Coordinator {
    public var navigationController: UINavigationController
    public var parentCoordinator: Coordinator?
    public var childCoordinators: [Coordinator] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let apiClient: APIClientProtocol
    
    public init(
        navigationController: UINavigationController,
        apiClient: APIClientProtocol
    ) {
        self.navigationController = navigationController
        self.apiClient = apiClient
    }
    
    public func start() {
        let repository = GithubRepositoryImpl(apiClient: apiClient)
        let getGitUserUsecase = GetGitUsersUsecaseImpl(repository: repository)
        let viewModel = UserListViewModel(context: .init(getGitUserUsecase: getGitUserUsecase))
        let ctr = UserListViewController(viewModel: viewModel)
        
        viewModel.outputPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                guard let self else { return }
                switch output {
                case .finish:
                    finish()
                case let .routeToDetail(username):
                    routeToGitUserDetail(with: username)
                }
            }.store(in: &cancellables)
        
        navigationController.pushViewController(ctr, animated: true)
    }
}

// MARK: - Cross coordinators

private extension UserListCoordinator {
    func routeToGitUserDetail(with username: String) {
        let coordinator = UserDetailCoordinator(
            navigationController: navigationController,
            apiClient: apiClient,
            username: username
        )
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
