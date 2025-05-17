import Foundation
import GlobalEntities

struct UserResponse: Decodable {
    let login: String?
    let avatarURL: String?
    let htmlURL: String?

    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
        case htmlURL   = "html_url"
    }
}

extension UserResponse {
    var parseToModel: UserModel {
        return .init(
            name: login ?? "",
            avatarURL: URL(string: avatarURL ?? ""),
            profileURL: URL(string: htmlURL ?? "")
        )
    }
}
