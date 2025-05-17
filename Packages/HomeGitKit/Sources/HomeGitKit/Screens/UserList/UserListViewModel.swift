import Foundation
import Combine
import CoreKit
import GlobalUsecase
import GlobalEntities
import NetworkProvider

// MARK: - Context & Output
extension UserListViewModel {
    /// Context
    struct Context {
        let getGitUserUsecase: GetGitUsersUsecase
        
        init(getGitUserUsecase: GetGitUsersUsecase) {
            self.getGitUserUsecase = getGitUserUsecase
        }
    }
    
    /// Output
    enum Output {
        case finish
        case routeToDetail(username: String)
    }
}

// MARK: - Section/Item
extension UserListViewModel {
    /// Section list
    enum Section: Hashable {
        case main
        
        var estimatedItemHeight: CGFloat { 122.0 } // minimum item height
    }
    
    /// Item of list
    enum Item: Hashable {
        case user(UserModel)
        case empty
    }
}

// MARK: - Main
final class UserListViewModel: BaseViewModel {
    // Props
    private let context: Context
    private let outputSubject = PassthroughSubject<Output, Never>()
    private let pageSize: Int = 20
    private var page: Int = 0
    private var hasMore: Bool = true
    
    // State
    @Published private(set) var users = [UserModel]()
    @Published private(set) var errorMessage: String?
    
    init(context: Context) {
        self.context = context
    }
    
    override func reset() {
        super.reset()
        outputSubject.send(.finish)
    }
}

// MARK: - Call from outside
extension UserListViewModel {
    func outputPublisher() -> AnyPublisher<Output, Never> {
        outputSubject.eraseToAnyPublisher()
    }
    
    func firstLoadData() {
        executeMainTask { [weak self] in
            guard let self else { return }
            if let cacheUsers = await UserCache.shared.loadUsers() { // Load cache if needed
                users = cacheUsers
                page = cacheUsers.count / pageSize
            } else {
                handleLoadList()
            }
        } onError: { [weak self] _ in
            self?.handleLoadList()
        }
    }
    
    func performUpdate() {
        guard hasMore else { return }
        handleLoadList(isPerformUpdate: true)
    }

    func handleUserItemTapped(for item: UserModel) {
        outputSubject.send(.routeToDetail(username: item.name))
    }
}

// MARK: Private Method

private extension UserListViewModel {
    func handleLoadList(isPerformUpdate: Bool = false) {
        executeMainTask { [weak self] in
            guard let self else { return }
            let result = try await context.getGitUserUsecase.execute(size: pageSize, since: pageSize * page)
            
            guard !Task.isCancelled else { return } // If task is cancelled, will not sinking it
            
            isPerformUpdate ? users.append(contentsOf: result) : (users = result)
            result.isEmpty ? (hasMore = false) : (page += 1)
            
            await handleCacheUsers(with: result)
        } onError: { [weak self] error in
            guard let self, !Task.isCancelled else { return }
            errorMessage = (error as? APIError)?.errorDescription
                            ?? error.localizedDescription
            
            if !isPerformUpdate {
                users = []
                hasMore = false
            }
        }
    }
    
    func handleCacheUsers(with users: [UserModel]) async {
        var exists = await UserCache.shared.loadUsers() ?? []
        
        for newUser in users where !exists.contains(where: { $0.id == newUser.id }) {
            exists.append(newUser)
        }

        await UserCache.shared.saveUsers(exists)
    }
}
