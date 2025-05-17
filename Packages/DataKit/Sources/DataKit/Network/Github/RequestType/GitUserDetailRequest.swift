import Foundation
import NetworkProvider

struct GitUserDetailRequest: APIRequest {    
    typealias Response = UserDetailResponse
    
    let allHeaders: [String: String]?
    let username: String
    
    init(
        headers: [String: String]?,
        username: String
    ) {
        self.allHeaders = headers
        self.username = username
    }

    var path: String { "/users/\(username)" }
    var headers: [String : String]? { allHeaders }
}
