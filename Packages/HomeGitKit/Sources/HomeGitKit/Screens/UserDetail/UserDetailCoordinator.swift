import CoreKit
import DataKit
import GlobalUsecase
import DomainRepositories
import UIKit
import Combine
import NetworkProvider

public final class UserDetailCoordinator: Coordinator {
    public var navigationController: UINavigationController
    public var parentCoordinator: Coordinator?
    public var childCoordinators: [Coordinator] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let apiClient: APIClientProtocol
    private let username: String
    
    public init(
        navigationController: UINavigationController,
        apiClient: APIClientProtocol,
        username: String
    ) {
        self.navigationController = navigationController
        self.apiClient = apiClient
        self.username = username
    }
    
    public func start() {
        let repository = GithubRepositoryImpl(apiClient: apiClient)
        let getGitUserDetailUsecase = GetGitUserDetailUsecaseImpl(repository: repository)
        let viewModel = UserDetailViewModel(context: .init(
            userName: username,
            getGitUserDetailUsecase: getGitUserDetailUsecase
        ))
        let ctr = UserDetailViewController(viewModel: viewModel)
        
        viewModel.outputPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                guard let self else { return }
                switch output {
                case .finish:
                    finish()
                }
            }.store(in: &cancellables)
        
        navigationController.pushViewController(ctr, animated: true)
    }
}
