import Foundation

public protocol APIClientProtocol {
    /// Sends an APIRequest, handles parameters, validates status codes, decodes JSON, and maps errors
    func send<T: APIRequest>(_ apiReq: T) async throws -> T.Response
}
