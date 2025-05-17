import Foundation
import NetworkProvider
import GlobalEntities
import DomainRepositories

// MARK: - Main
public struct GithubRepositoryImpl {
    private let apiClient: APIClientProtocol
    private let headers: [String: String]?
    
    public init(
        apiClient: APIClientProtocol,
        headers: [String: String]? = nil
    ) {
        self.apiClient = apiClient
        self.headers = headers
    }
}

// MARK: - Handle fetch service
extension GithubRepositoryImpl: GitUsersRepository {
    public func fetchGitUsers(size: Int, since: Int) async throws -> [UserModel] {
        let parameters: [String: Any] = ["per_page": size, "since": since]
        let request = GitUserListRequest(headers: headers, parameters: parameters)
        let response = try await apiClient.send(request)
        return response.map(\.parseToModel)
    }
    
    public func fetchGitUserDetail(username: String) async throws -> UserModel {
        let request = GitUserDetailRequest(headers: headers, username: username)
        let response = try await apiClient.send(request)
        return response.parseToModel
    }
}
