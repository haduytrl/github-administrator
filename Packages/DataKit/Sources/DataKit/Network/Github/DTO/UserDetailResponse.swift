import Foundation
import GlobalEntities

struct UserDetailResponse: Decodable {
    let login: String?
    let avatarURL: String?
    let htmlURL: String?
    let location: String?
    let followers: Int?
    let following: Int?
    let blog: String?

    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
        case htmlURL   = "html_url"
        case location
        case followers
        case following
        case blog
    }
}

extension UserDetailResponse {
    var parseToModel: UserModel {
        return .init(
            name: login ?? "",
            avatarURL: URL(string: avatarURL ?? ""),
            profileURL: URL(string: htmlURL ?? ""),
            location: location ?? "",
            followers: followers ?? 0,
            following: following ?? 0,
            blog: blog ?? ""
        )
    }
}
