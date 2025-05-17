import Foundation

public enum APIError: Error, Equatable {
    case mappingError
    case decodingError
    case invalidResponse(statusCode: Int?)
    case networkError(_ message: String)
    case unknownError(_ message: String)
    
    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.decodingError, .decodingError): return true
        case (let .invalidResponse(lhsCode), let .invalidResponse(rhsCode)):
            return lhsCode == rhsCode
        case (let .networkError(lhsMsg), let .networkError(rhsMsg)):
            return lhsMsg == rhsMsg
        case (let .unknownError(lhsMsg), let .unknownError(rhsMsg)):
            return lhsMsg == rhsMsg
        default: return false
        }
    }
    
    public var errorDescription: String {
        switch self {
        case .mappingError:
            return "Failed to mapping the request/response payloads."
        case .decodingError:
            return "Failed to decode the response from the server."
        case let .invalidResponse(code):
            return "Invalid response from server. Status code: \(code ?? -1)"
        case let .networkError(msg):
            return "Network error: \(msg)"
        case let .unknownError(msg):
            return "Unknown error: \(msg)"
        }
    }
}
