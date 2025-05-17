import Foundation
import Alamofire

public class APIClient: APIClientProtocol {
    private let session: Session
    private let baseURL: URL
    private let defaultHeaders: [String: String]?
    
    /// By default we attach our logger
    public init(
        baseURL: String,
        defaulHeaders: [String: String]? = nil,
        session: Session = Session(
            configuration: URLSessionConfiguration.af.default,
            interceptor: nil,
            eventMonitors: [LoggingEventMonitor()]
        )
    ) {
        self.baseURL = URL(string: baseURL)!
        self.session = session
        self.defaultHeaders = defaulHeaders
    }
    
    /// Sends any APIRequest, handles params vs body vs queryItems,
    /// validates status codes, decodes JSON, and maps errors.
    public func send<T: APIRequest>(_ apiReq: T) async throws -> T.Response {
        let url = baseURL.appendingPathComponent(apiReq.path)
        let request: DataRequest
        let headers = HTTPHeaders(apiReq.headers ?? defaultHeaders ?? [:])
        
        if let encodable = apiReq.body {
            // If you have a body, JSON‐encode it
            request = session.request(
                url,
                method: apiReq.method,
                parameters: encodable,
                encoder: JSONParameterEncoder.default,
                headers: headers
            )
        } else {
            // Otherwise use your parameters + encoding
            request = session.request(
                url,
                method: apiReq.method,
                parameters: apiReq.parameters,
                encoding: apiReq.encoding,
                headers: headers
            )
        }
        
        // ── Validate, decode & map errors ──
        let dataResp = await request
            .validate(statusCode: 200..<300)
            .serializingDecodable(T.Response.self)
            .response
        
        switch dataResp.result {
        case .success(let value):
            return value
        case .failure(let afError):
            throw mapError(afError, statusCode: dataResp.response?.statusCode)
        }
    }
}

// MARK: - Private Methods

private extension APIClient {
    /// Map AFError to APIError
    func mapError(_ error: Error, statusCode: Int?) -> APIError {
        guard let afError = error as? AFError else {
            return .unknownError(error.localizedDescription)
        }
        
        switch afError {
        case let .sessionTaskFailed(urlErr):
            return .networkError(urlErr.localizedDescription)
        case .responseSerializationFailed:
            return .decodingError
        default:
            return .invalidResponse(statusCode: statusCode)
        }
    }
}
