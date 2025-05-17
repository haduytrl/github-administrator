import Foundation
import GlobalEntities
import DomainRepositories

public protocol GetGitUserDetailUsecase {
    func execute(username: String) async throws -> UserModel
}

public final class GetGitUserDetailUsecaseImpl: GetGitUserDetailUsecase {
    private let repository: GitUsersRepository
    
    public init(repository: GitUsersRepository) {
        self.repository = repository
    }
    
    public func execute(username: String) async throws -> UserModel {
        try await repository.fetchGitUserDetail(username: username)
    }
}
