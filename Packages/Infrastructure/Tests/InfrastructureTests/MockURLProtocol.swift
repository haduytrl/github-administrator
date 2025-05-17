import Foundation

class MockURLProtocol: URLProtocol {
    static var responseData: Data?
    static var error: Error?
    static var statusCode: Int?
    
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    
    override func startLoading() {
        if let error = MockURLProtocol.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        if let data = MockURLProtocol.responseData, let response = HTTPURLResponse(
            url: request.url!,
            statusCode: MockURLProtocol.statusCode ?? 200,
            httpVersion: nil,
            headerFields: nil
        ) {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
}
