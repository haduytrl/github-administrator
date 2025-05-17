import XCTest
import NetworkProvider
import GlobalEntities
import DomainRepositories
@testable import DataKit

final class GithubRepositoryImplTests: XCTestCase {
    
    // MARK: - Properties
    
    private var mockAPIClient: MockAPIClient!
    private var sut: GithubRepositoryImpl!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        sut = GithubRepositoryImpl(apiClient: mockAPIClient)
    }
    
    override func tearDown() {
        mockAPIClient = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testFetchGitUsers() async throws {
        // Given
        let mockUsers = [
            UserResponse(login: "user1", avatarURL: "https://example.com/avatar1.jpg", htmlURL: "https://github.com/user1"),
            UserResponse(login: "user2", avatarURL: "https://example.com/avatar2.jpg", htmlURL: "https://github.com/user2")
        ]
        mockAPIClient.mockResponse = mockUsers
        
        // When
        let result = try await sut.fetchGitUsers(size: 2, since: 0)
        
        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].name, "user1")
        XCTAssertEqual(result[1].name, "user2")
        
        // Verify the request was made with correct parameters
        if let requestTypeSent = mockAPIClient.lastRequestSent as? GitUserListRequest {
            XCTAssertEqual(requestTypeSent.path, "/users")
            XCTAssertNotNil(requestTypeSent.parameters)
            XCTAssertEqual(requestTypeSent.parameters?["per_page"] as? Int, 2)
            XCTAssertEqual(requestTypeSent.parameters?["since"] as? Int, 0)
        } else {
            XCTFail("Expected GitUserListRequest")
        }
    }
    
    func testFetchGitUserDetail() async throws {
        // Given
        let mockUserDetail = UserDetailResponse(
            login: "testuser",
            avatarURL: "https://example.com/avatar.jpg",
            htmlURL: "https://github.com/testuser",
            location: "San Francisco",
            followers: 100,
            following: 50,
            blog: "https://testuser.com"
        )
        mockAPIClient.mockResponse = mockUserDetail
        
        // When
        let username = "testuser"
        let result = try await sut.fetchGitUserDetail(username: username)
        
        // Then
        XCTAssertEqual(result.name, username)
        XCTAssertEqual(result.location, "San Francisco")
        XCTAssertEqual(result.followers, 100)
        XCTAssertEqual(result.following, 50)
        XCTAssertEqual(result.blog, "https://testuser.com")
        
        // Verify request was made with correct username
        if let requestTypeSent = mockAPIClient.lastRequestSent as? GitUserDetailRequest {
            XCTAssertEqual(requestTypeSent.path, "/users/\(username)")
            XCTAssertEqual(requestTypeSent.username, username)
        } else {
            XCTFail("Expected GitUserDetailRequest")
        }
    }
    
    func testFetchGitUsers_WithError() async {
        // Given
        let mockError = APIError.networkError("Network error")
        mockAPIClient.mockError = mockError
        
        // When/Then
        do {
            _ = try await sut.fetchGitUsers(size: 1, since: 0)
            XCTFail("Expected error to be thrown")
        } catch {
            // Success - error was thrown
            XCTAssertTrue(true)
        }
    }
    
    func testFetchGitUserDetail_WithError() async {
        // Given
        let mockError = APIError.networkError("Network error")
        mockAPIClient.mockError = mockError
        
        // When/Then
        do {
            _ = try await sut.fetchGitUserDetail(username: "testuser")
            XCTFail("Expected error to be thrown")
        } catch {
            // Success - error was thrown
            XCTAssertTrue(true)
        }
    }
}

// MARK: - Mock Helper

private class MockAPIClient: APIClientProtocol {
    var mockResponse: Any?
    var mockError: Error?
    var lastRequestSent: (any APIRequest)?
    
    func send<T: APIRequest>(_ apiReq: T) async throws -> T.Response {
        lastRequestSent = apiReq
        
        if let error = mockError {
            throw error
        }
        
        guard let response = mockResponse as? T.Response else {
            throw APIError.decodingError
        }
        
        return response
    }
}
