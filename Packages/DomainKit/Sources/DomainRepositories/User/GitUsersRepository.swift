import Foundation
import GlobalEntities

// Interfaces
public protocol GitUsersRepository {
    func fetchGitUsers(size: Int, since: Int) async throws -> [UserModel]
    func fetchGitUserDetail(username: String) async throws -> UserModel
}
