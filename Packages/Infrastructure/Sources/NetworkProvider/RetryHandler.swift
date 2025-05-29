import Alamofire
import Foundation

public final class RetryHandler: RequestInterceptor {
    let retryLimit: Int = 2
    let retryDelay: TimeInterval = 1.5
    
    public init() {}
    
    public func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        let retryCount = request.retryCount
        
        if let statusCode = request.response?.statusCode,
           statusCode == 500,
           retryCount < retryLimit
        {
            #if DEBUG
            debugPrint("Retrying request: \(retryCount + 1)")
            #endif
            
            completion(.retryWithDelay(retryDelay))
        } else {
            completion(.doNotRetry)
        }
    }
}
