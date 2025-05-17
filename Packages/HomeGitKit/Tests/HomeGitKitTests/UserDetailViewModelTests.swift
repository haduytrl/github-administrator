import XCTest
import Combine
import CoreKit
import GlobalUsecase
import GlobalEntities
import NetworkProvider
@testable import HomeGitKit

final class UserDetailViewModelTests: XCTestCase {
    // MARK: - Properties
    
    private var mockUseCase: MockGetGitUserDetailUsecase!
    private var sut: UserDetailViewModel!
    private var cancellables: Set<AnyCancellable>!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockGetGitUserDetailUsecase()
        
        let context = UserDetailViewModel.Context(
            userName: "testuser",
            getGitUserDetailUsecase: mockUseCase
        )
        
        sut = UserDetailViewModel(context: context)
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
        let expectation = expectation(description: "Should handle load data")
        let mockUser = UserModel(
            name: "testuser",
            avatarURL: URL(string: "https://example.com/avatar.jpg"),
            profileURL: URL(string: "https://github.com/testuser"),
            location: "San Francisco",
            followers: 100,
            following: 50,
            blog: "https://testuser.com"
        )
        mockUseCase.mockResult = mockUser
        
        var loadedDetail: UserModel?
        
        // When
        sut.$detail
            .dropFirst() // Skip initial nil value
            .sink { detail in
                loadedDetail = detail
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.firstLoadData()
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertNotNil(loadedDetail)
        XCTAssertEqual(loadedDetail?.name, "testuser")
        XCTAssertEqual(loadedDetail?.location, "San Francisco")
        XCTAssertEqual(loadedDetail?.followers, 100)
        XCTAssertEqual(loadedDetail?.following, 50)
        XCTAssertEqual(loadedDetail?.blog, "https://testuser.com")
        XCTAssertEqual(mockUseCase.lastUsernameRequested, "testuser")
    }
    
    func test_firstLoadData_Error() {
        // Given
        let expectation = expectation(description: "Should handle error")
        let mockError = APIError.networkError("Network error")
        mockUseCase.mockError = mockError
        
        var receivedErrorMessage: String?
        
        // When
        sut.$errorMessage
            .dropFirst() // Skip initial nil value
            .sink { errorMessage in
                receivedErrorMessage = errorMessage
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.firstLoadData()
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertNotNil(receivedErrorMessage)
        XCTAssertTrue(!receivedErrorMessage!.isEmpty)
    }
    
    func test_reset_SendsFinishOutput() {
        // Given
        let expectation = expectation(description: "Should send finish output")
        
        sut.outputPublisher()
            .sink { output in
                if case .finish = output {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        sut.reset()
        
        // Then
        waitForExpectations(timeout: 1.0)
    }
}

// MARK: - Mock Helper

private class MockGetGitUserDetailUsecase: GetGitUserDetailUsecase {
    var mockResult: UserModel?
    var mockError: Error?
    
    var lastUsernameRequested: String?
    
    func execute(username: String) async throws -> UserModel {
        lastUsernameRequested = username
        
        guard let error = mockError else {
            return mockResult ?? UserModel(name: username, avatarURL: nil, profileURL: nil)
        }
        throw error
    }
} 
