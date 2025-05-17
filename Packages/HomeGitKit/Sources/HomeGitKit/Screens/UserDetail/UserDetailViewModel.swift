import Foundation
import Combine
import CoreKit
import GlobalUsecase
import GlobalEntities
import NetworkProvider

// MARK: - Context & Output
extension UserDetailViewModel {
    /// Context
    struct Context {
        let userName: String
        let getGitUserDetailUsecase: GetGitUserDetailUsecase
        
        init(
            userName: String,
            getGitUserDetailUsecase: GetGitUserDetailUsecase
        ) {
            self.userName = userName
            self.getGitUserDetailUsecase = getGitUserDetailUsecase
        }
    }

    /// Output
    enum Output {
        case finish
    }
}

// MARK: - Main
final class UserDetailViewModel: BaseViewModel {
    // Props
    private let context: Context
    private let outputSubject = PassthroughSubject<Output, Never>()
    
    // State
    @Published private(set) var detail: UserModel?
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
extension UserDetailViewModel {
    func outputPublisher() -> AnyPublisher<Output, Never> {
        outputSubject.eraseToAnyPublisher()
    }
    
    func firstLoadData() {
        executeMainTask { [weak self] in
            guard let self else { return }
            let result = try await context.getGitUserDetailUsecase.execute(username: context.userName)
            
            guard !Task.isCancelled else { return }
            
            detail = result
        } onError: { [weak self] error in
            guard let self, !Task.isCancelled else { return }
            errorMessage = (error as? APIError)?.errorDescription
                            ?? error.localizedDescription
            detail = nil
        }
    }
}
