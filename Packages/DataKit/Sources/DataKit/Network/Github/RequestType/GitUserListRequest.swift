import Foundation
import NetworkProvider

struct GitUserListRequest: APIRequest {
    typealias Response = [UserResponse]
    
    let allHeaders: [String: String]?
    let params: [String: Any]
    
    init(
        headers: [String: String]?,
        parameters: [String: Any]
    ) {
        self.allHeaders = headers
        self.params = parameters
    }

    var parameters: [String: Any]? { params }
    var path: String { "/users" }
    var headers: [String : String]? { allHeaders }
}
