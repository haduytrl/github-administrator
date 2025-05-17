import XCTest
@testable import GlobalEntities

final class UserModelTests: XCTestCase {
    func test_UserModel_Initialization() {
        // Given
        let name = "testuser"
        let avatarURL = URL(string: "https://example.com/avatar.jpg")
        let profileURL = URL(string: "https://github.com/testuser")
        let location = "San Francisco"
        let followers = 100
        let following = 50
        let blog = "https://testuser.com"
        
        // When
        let user = UserModel(
            name: name,
            avatarURL: avatarURL,
            profileURL: profileURL,
            location: location,
            followers: followers,
            following: following,
            blog: blog
        )
        
        // Then
        XCTAssertEqual(user.name, name)
        XCTAssertEqual(user.avatarURL, avatarURL)
        XCTAssertEqual(user.profileURL, profileURL)
        XCTAssertEqual(user.location, location)
        XCTAssertEqual(user.followers, followers)
        XCTAssertEqual(user.following, following)
        XCTAssertEqual(user.blog, blog)
        XCTAssertFalse(user.id.isEmpty)
    }
    
    func test_UserModel_InitializationWithDefaultValues() {
        // Given
        let name = "testuser"
        let avatarURL = URL(string: "https://example.com/avatar.jpg")
        let profileURL = URL(string: "https://github.com/testuser")
        
        // When
        let user = UserModel(
            name: name,
            avatarURL: avatarURL,
            profileURL: profileURL
        )
        
        // Then
        XCTAssertEqual(user.name, name)
        XCTAssertEqual(user.avatarURL, avatarURL)
        XCTAssertEqual(user.profileURL, profileURL)
        XCTAssertEqual(user.location, "")
        XCTAssertEqual(user.followers, 0)
        XCTAssertEqual(user.following, 0)
        XCTAssertEqual(user.blog, "")
        XCTAssertFalse(user.id.isEmpty)
    }
} 
