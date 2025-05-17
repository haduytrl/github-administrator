import Foundation
import GlobalEntities
import DomainRepositories

public protocol GetGitUsersUsecase {
    func execute(size: Int, since: Int) async throws -> [UserModel]
}

public final class GetGitUsersUsecaseImpl: GetGitUsersUsecase {
    private let repository: GitUsersRepository
    
    public init(repository: GitUsersRepository) {
        self.repository = repository
    }
    
    public func execute(size: Int, since: Int) async throws -> [UserModel] {
        try await repository.fetchGitUsers(size: size, since: since)
    }
}
