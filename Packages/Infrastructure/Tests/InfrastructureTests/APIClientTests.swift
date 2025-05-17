import XCTest
import Alamofire
@testable import NetworkProvider

final class APIClientTests: XCTestCase {
    
    // MARK: - Properties
    
    private var mockSession: Session!
    private var sut: APIClient!
    private let baseURL = "https://api.example.com"
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        
        // Setup for each test
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockURLProtocol.self]
        mockSession = Session(configuration: configuration, eventMonitors: [LoggingEventMonitor()])
        
        sut = APIClient(baseURL: baseURL, session: mockSession)
    }
    
    override func tearDown() {
        mockSession = nil
        sut = nil
        MockURLProtocol.responseData = nil
        MockURLProtocol.error = nil
        MockURLProtocol.statusCode = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_SuccessfulRequest() async throws {
        // Given
        let expectedResponse = MockResponse(id: 123, name: "Test")
        let jsonData = try JSONEncoder().encode(expectedResponse)
        
        MockURLProtocol.responseData = jsonData
        MockURLProtocol.statusCode = 200
        
        // When
        let response = try await sut.send(MockRequest())
        
        // Then
        XCTAssertEqual(response.id, expectedResponse.id)
        XCTAssertEqual(response.name, expectedResponse.name)
    }
    
    func test_NetworkError() async {
        // Given
        let urlError = URLError(.notConnectedToInternet)
        MockURLProtocol.error = urlError
        
        // When/Then
        do {
            _ = try await sut.send(MockRequest())
            XCTFail("Expected networkError to be thrown")
        } catch let error as APIError {
            guard case .networkError(_) = error else {
                XCTFail("Expected networkError but got \(error)")
                return
            }
            XCTAssertTrue(true)
        } catch {
            XCTFail("Expected APIError but got \(error)")
        }
    }
    
    func test_DecodingError() async {
        // Given
        MockURLProtocol.responseData = "Invalid-JSON".data(using: .utf8)
        MockURLProtocol.statusCode = 200
        
        // When/Then
        do {
            _ = try await sut.send(MockRequest())
            XCTFail("Expected decodingError to be thrown")
        } catch let error as APIError {
            XCTAssertEqual(error, .decodingError)
        } catch {
            XCTFail("Expected APIError but got \(error)")
        }
    }
    
    func test_InvalidResponseError() async {
        // Given
        MockURLProtocol.responseData = Data()
        MockURLProtocol.statusCode = 404
        
        // When/Then
        do {
            _ = try await sut.send(MockRequest())
            XCTFail("Expected invalidResponse to be thrown")
        } catch let error as APIError {
            guard case let .invalidResponse(statusCode) = error else {
                XCTFail("Expected invalidResponse but got \(error)")
                return
            }
            XCTAssertEqual(statusCode, 404)
        } catch {
            XCTFail("Expected APIError but got \(error)")
        }
    }
    
    func test_RequestWithBody() async throws {
        // Given
        let expectedResponse = MockResponse(id: 123, name: "Test")
        let jsonData = try JSONEncoder().encode(expectedResponse)
        
        MockURLProtocol.responseData = jsonData
        MockURLProtocol.statusCode = 200
        
        // When
        let response = try await sut.send(MockRequestWithBody())
        
        // Then
        XCTAssertEqual(response.id, expectedResponse.id)
    }
}

// MARK: - Mock Types

private struct MockRequest: APIRequest {
    typealias Response = MockResponse
    
    var path: String { "/test" }
    var method: HTTPMethod { .get }
    var parameters: [String: Any]? { ["key": "value"] }
    var headers: [String: String]? { nil }
}

private struct MockRequestWithBody: APIRequest {
    typealias Response = MockResponse
    
    struct Body: Encodable {
        let name: String
        let age: Int
    }
    
    var path: String { "/test-body" }
    var method: HTTPMethod { .post }
    var parameters: [String: Any]? { nil }
    var body: Encodable? { Body(name: "Test", age: 30) }
    var headers: [String: String]? { nil }
}

private struct MockResponse: Codable, Equatable {
    let id: Int
    let name: String
}
