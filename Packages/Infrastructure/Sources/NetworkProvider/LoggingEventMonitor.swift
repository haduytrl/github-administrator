import Foundation
import Alamofire

public final class LoggingEventMonitor: EventMonitor {
    public init() {}

    // Call when Request Started
    public func requestDidResume(_ request: Request) {
        #if DEBUG
        // Print the request header
        debugPrint("------------ REQUEST STARTED ------------")
        debugPrint()
        // get cURL once the URLRequest is finalized
        request.cURLDescription {
            debugPrint(">>> cURL: \($0)")
            debugPrint()
        }
        #endif
    }

    // Call when Response Received
    public func request<Value>(
        _ request: DataRequest,
        didParseResponse response: DataResponse<Value, AFError>
    ) {
        #if DEBUG
        debugPrint("------------ RESPONSE RECEIVED ------------")
        debugPrint()
        debugPrint(">>> Response:", response.debugDescription)
        debugPrint()
        #endif
    }
}
