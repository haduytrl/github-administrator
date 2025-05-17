import XCTest
import GlobalEntities
import DomainRepositories
@testable import GlobalUsecase

final class GetGitUserDetailUsecaseTests: XCTestCase {
    // MARK: - Properties
    
    private var mockRepository: MockGitUsersRepository!
    private var sut: GetGitUserDetailUsecaseImpl!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        mockRepository = MockGitUsersRepository()
        sut = GetGitUserDetailUsecaseImpl(repository: mockRepository)
    }
    
    override func tearDown() {
        mockRepository = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testExecute_Success() async throws {
        // Given
        let username = "octocat"
        let expectedUser = UserModel(
            name: username,
            avatarURL: URL(string: "https://example.com/avatar.jpg"),
            profileURL: URL(string: "https://github.com/octocat"),
            location: "San Francisco",
            followers: 1000,
            following: 50,
            blog: "https://octocat.com"
        )
        mockRepository.user = expectedUser
        
        // When
        let result = try await sut.execute(username: username)
        
        // Then
        XCTAssertEqual(result.name, username)
        XCTAssertEqual(result.location, "San Francisco")
        XCTAssertEqual(result.followers, 1000)
        XCTAssertEqual(result.following, 50)
        XCTAssertEqual(result.blog, "https://octocat.com")
        
        // Verify correct parameters were passed to repository
        XCTAssertEqual(mockRepository.lastUsernameRequested, username)
        XCTAssertTrue(mockRepository.fetchGitUserDetailCalled)
    }
    
    func testExecute_Error() async {
        // Given
        let username = "octocat"
        mockRepository.error = TestError()
        
        // When/Then
        do {
            _ = try await sut.execute(username: username)
            XCTFail("Expected error to be thrown")
        } catch is TestError {
            // Success - correct error was thrown
            XCTAssertTrue(true)
        } catch {
            XCTFail("Wrong error type thrown: \(error)")
        }
        
        // Verify correct parameters were passed to repository
        XCTAssertEqual(mockRepository.lastUsernameRequested, username)
        XCTAssertTrue(mockRepository.fetchGitUserDetailCalled)
    }
}

// MARK: - Mock Helper

private class MockGitUsersRepository: GitUsersRepository {
    var users: [UserModel] = []
    var user: UserModel?
    var error: Error?
    
    var fetchGitUsersCalled = false
    var fetchGitUserDetailCalled = false
    
    var lastUsernameRequested: String?
    
    func fetchGitUsers(size: Int, since: Int) async throws -> [UserModel] { [] }
    
    func fetchGitUserDetail(username: String) async throws -> UserModel {
        fetchGitUserDetailCalled = true
        lastUsernameRequested = username
        
        guard let error = error else {
            return user ?? UserModel(name: username, avatarURL: nil, profileURL: nil)
        }
        throw error
    }
}

private struct TestError: Error {}
