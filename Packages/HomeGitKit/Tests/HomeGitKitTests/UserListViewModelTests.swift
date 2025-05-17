import XCTest
import Combine
import CoreKit
import GlobalUsecase
import GlobalEntities
import NetworkProvider
@testable import HomeGitKit

final class UserListViewModelTests: XCTestCase {
    // MARK: - Properties
    
    private var mockUseCase: MockGetGitUsersUsecase!
    private var sut: UserListViewModel!
    private var cancellables: Set<AnyCancellable>!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockGetGitUsersUsecase()
        
        let context = UserListViewModel.Context(getGitUserUsecase: mockUseCase)
        sut = UserListViewModel(context: context)
        cancellables = []
    }
    
    override func tearDown() {
        mockUseCase = nil
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_firstLoadData_Success() {
        // Given
        let expectation = expectation(description: "Should load users")
        let mockUsers = [
            UserModel(name: "user1", avatarURL: URL(string: "https://example.com/avatar1"), profileURL: URL(string: "https://github.com/user1")),
            UserModel(name: "user2", avatarURL: URL(string: "https://example.com/avatar2"), profileURL: URL(string: "https://github.com/user2"))
        ]
        mockUseCase.mockResult = mockUsers
        
        var loadedUsers: [UserModel] = []
        
        // When
        sut.$users
            .dropFirst() // Skip initial empty value
            .sink { users in
                loadedUsers = users
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.firstLoadData()
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(loadedUsers.count, 2)
        XCTAssertEqual(loadedUsers[0].name, "user1")
        XCTAssertEqual(loadedUsers[1].name, "user2")
    }
    
    func test_firstLoadData_Error() {
        // Given
        let mockError = APIError.networkError("Network error")
        mockUseCase.mockError = mockError
        
        // When
        sut.$errorMessage
            .dropFirst() // Skip initial nil value
            .sink { errorMessage in
                // Then
                XCTAssertNotNil(errorMessage)
                XCTAssertTrue(!errorMessage!.isEmpty)
            }
            .store(in: &cancellables)
        
        sut.firstLoadData()
    }
    
    func test_handleUserItemTapped_SendsRouteOutput() {
        // Given
        let user = UserModel(name: "testuser", avatarURL: nil, profileURL: nil)
        
        sut.outputPublisher()
            .sink { output in
                // Then
                if case let .routeToDetail(username) = output {
                    XCTAssertEqual(username, "testuser")
                }
            }
            .store(in: &cancellables)
        
        // When
        sut.handleUserItemTapped(for: user)
    }
    
    func test_reset_SendsFinishOutput() {
        // Given
        sut.outputPublisher()
            .sink { output in
                // Then
                if case .finish = output {
                    XCTAssertTrue(true)
                } else {
                    XCTFail()
                }
            }
            .store(in: &cancellables)
        
        // When
        sut.reset()
    }
}

// MARK: - Mock Helper

private class MockGetGitUsersUsecase: GetGitUsersUsecase {
    var mockResult: [UserModel] = []
    var mockError: Error?
    var executionCount = 0
    
    func execute(size: Int, since: Int) async throws -> [UserModel] {
        executionCount += 1
        
        guard let error = mockError else { return mockResult }
        throw error
    }
}
