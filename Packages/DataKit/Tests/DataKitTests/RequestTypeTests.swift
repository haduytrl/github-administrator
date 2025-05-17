import XCTest
import NetworkProvider
@testable import DataKit

final class RequestTypeTests: XCTestCase {
    func testGitUserListRequest() {
        // Given
        let headers = ["Content-Type": "application/json;charset=utf-8"]
        let parameters: [String: Any] = ["per_page": 10, "since": 100]
        
        // When
        let request = GitUserListRequest(headers: headers, parameters: parameters)
        
        // Then
        XCTAssertEqual(request.path, "/users")
        XCTAssertEqual(request.headers?["Content-Type"], "application/json;charset=utf-8")
        XCTAssertEqual(request.parameters?["per_page"] as? Int, 10)
        XCTAssertEqual(request.parameters?["since"] as? Int, 100)
        XCTAssertEqual(request.method, .get) // Default from APIRequest
    }
    
    func testGitUserDetailRequest() {
        // Given
        let headers = ["Content-Type": "application/json;charset=utf-8"]
        let username = "octocat"
        
        // When
        let request = GitUserDetailRequest(headers: headers, username: username)
        
        // Then
        XCTAssertEqual(request.path, "/users/octocat")
        XCTAssertEqual(request.headers?["Content-Type"], "application/json;charset=utf-8")
        XCTAssertEqual(request.username, "octocat")
        XCTAssertEqual(request.method, .get) // Default from APIRequest
    }
} 
