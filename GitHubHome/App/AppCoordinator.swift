import UIKit
import CoreKit
import HomeGitKit
import NetworkProvider

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
        
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showUserList()
    }
    
    private func showUserList() {
        let apiClient = APIClient(
            baseURL: Environment.Config.baseURL,
            defaulHeaders: Environment.Config.defaultHeaders
        )
        let userListCoordinator = UserListCoordinator(navigationController: navigationController, apiClient: apiClient)
        userListCoordinator.parentCoordinator = self
        childCoordinators.append(userListCoordinator)
        userListCoordinator.start()
    }
}
