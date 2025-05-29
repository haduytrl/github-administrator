import XCTest
import GlobalEntities
import DomainRepositories
@testable import GlobalUsecase

final class GetGitUsersUsecaseTests: XCTestCase {
    // MARK: - Properties
    
    private var mockRepository: MockGitUsersRepository!
    private var sut: GetGitUsersUsecaseImpl!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        mockRepository = MockGitUsersRepository()
        sut = GetGitUsersUsecaseImpl(repository: mockRepository)
    }
    
    override func tearDown() {
        mockRepository = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testExecute_Success() async throws {
        // Given
        let expectedUsers = [
            UserModel(name: "user1", avatarURL: URL(string: "https://example.com/avatar1"), profileURL: URL(string: "https://github.com/user1")),
            UserModel(name: "user2", avatarURL: URL(string: "https://example.com/avatar2"), profileURL: URL(string: "https://github.com/user2"))
        ]
        mockRepository.users = expectedUsers
        
        // When
        let result = try await sut.execute(size: 2, since: 0)
        
        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].name, "user1")
        XCTAssertEqual(result[1].name, "user2")
        
        // Verify correct parameters were passed to repository
        XCTAssertEqual(mockRepository.lastSizeRequested, 2)
        XCTAssertEqual(mockRepository.lastSinceRequested, 0)
        XCTAssertTrue(mockRepository.fetchGitUsersCalled)
    }
    
    func testExecute_Error() async {
        // Given
        mockRepository.error = TestError()
        
        // When/Then
        do {
            _ = try await sut.execute(size: 1, since: 0)
            XCTFail("Expected error to be thrown")
        } catch is TestError {
            // Success - correct error was thrown
            XCTAssertTrue(true)
        } catch {
            XCTFail("Wrong error type thrown: \(error)")
        }
        
        // Verify correct parameters were passed to repository
        XCTAssertEqual(mockRepository.lastSizeRequested, 1)
        XCTAssertEqual(mockRepository.lastSinceRequested, 0)
        XCTAssertTrue(mockRepository.fetchGitUsersCalled)
    }
}

// MARK: - Mock Helper

private class MockGitUsersRepository: GitUsersRepository {
    var users: [UserModel] = []
    var user: UserModel?
    var error: Error?
    
    var fetchGitUsersCalled = false
    
    var lastSizeRequested: Int?
    var lastSinceRequested: Int?
    var lastUsernameRequested: String?
    
    func fetchGitUsers(size: Int, since: Int) async throws -> [UserModel] {
        fetchGitUsersCalled = true
        lastSizeRequested = size
        lastSinceRequested = since
        
        guard let error = error else { return users }
        throw error
    }
    
    func fetchGitUserDetail(username: String) async throws -> UserModel {
        return .init(name: "", avatarURL: nil, profileURL: nil)
    }
}

private struct TestError: Error {}
