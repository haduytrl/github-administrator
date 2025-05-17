import XCTest
import GlobalEntities
@testable import DataKit

final class DTOTests: XCTestCase {
    func testUserResponseMapping() {
        // Given
        let userResponse = UserResponse(
            login: "testuser",
            avatarURL: "https://example.com/avatar.jpg",
            htmlURL: "https://github.com/testuser"
        )
        
        // When
        let userModel = userResponse.parseToModel
        
        // Then
        XCTAssertEqual(userModel.name, "testuser")
        XCTAssertEqual(userModel.avatarURL?.absoluteString, "https://example.com/avatar.jpg")
        XCTAssertEqual(userModel.profileURL?.absoluteString, "https://github.com/testuser")
    }
    
    func testUserResponseMapping_WithNilValues() {
        // Given
        let userResponse = UserResponse(
            login: nil,
            avatarURL: nil,
            htmlURL: nil
        )
        
        // When
        let userModel = userResponse.parseToModel
        
        // Then
        XCTAssertEqual(userModel.name, "")
        XCTAssertNil(userModel.avatarURL)
        XCTAssertNil(userModel.profileURL)
    }
    
    func testUserDetail_ResponseMapping() {
        // Given
        let userDetailResponse = UserDetailResponse(
            login: "testuser",
            avatarURL: "https://example.com/avatar.jpg",
            htmlURL: "https://github.com/testuser",
            location: "San Francisco",
            followers: 100,
            following: 50,
            blog: "https://testuser.com"
        )
        
        // When
        let userModel = userDetailResponse.parseToModel
        
        // Then
        XCTAssertEqual(userModel.name, "testuser")
        XCTAssertEqual(userModel.avatarURL?.absoluteString, "https://example.com/avatar.jpg")
        XCTAssertEqual(userModel.profileURL?.absoluteString, "https://github.com/testuser")
        XCTAssertEqual(userModel.location, "San Francisco")
        XCTAssertEqual(userModel.followers, 100)
        XCTAssertEqual(userModel.following, 50)
        XCTAssertEqual(userModel.blog, "https://testuser.com")
    }
    
    func testUserDetailResponseMapping_WithNilValues() {
        // Given
        let userDetailResponse = UserDetailResponse(
            login: nil,
            avatarURL: nil,
            htmlURL: nil,
            location: nil,
            followers: nil,
            following: nil,
            blog: nil
        )
        
        // When
        let userModel = userDetailResponse.parseToModel
        
        // Then
        XCTAssertEqual(userModel.name, "")
        XCTAssertNil(userModel.avatarURL)
        XCTAssertNil(userModel.profileURL)
        XCTAssertEqual(userModel.location, "")
        XCTAssertEqual(userModel.followers, 0)
        XCTAssertEqual(userModel.following, 0)
        XCTAssertEqual(userModel.blog, "")
    }
} 
