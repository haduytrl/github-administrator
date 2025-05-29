import Alamofire
import Foundation

public protocol APIRequest {
    associatedtype Response: Decodable
    
    /// e.g. "/users"
    var path: String { get }
    var method: HTTPMethod { get }
    
    /// For URL/form parameters or JSON body (if `body` is nil)
    var parameters: [String: Any]? { get }
    
    /// An `Encodable` request-body (takes priority over `parameters`)
    var body: Encodable? { get }
    
    /// Which encoder to use if `parameters` is non-nil
    var encoding: ParameterEncoding { get }
    
    /// Any extra headers (e.g. auth)
    var headers: [String: String]? { get }
}

// MARK: - Default
public extension APIRequest {
    var method: HTTPMethod              { .get }
    var parameters: [String: Any]?      { nil }
    var body: Encodable?                { nil }
    var encoding: ParameterEncoding     { URLEncoding.default }
}
