import Foundation

public struct UserModel: Hashable, Codable { // Codable for save/load data from persistent storage
    public let id: String
    public let name: String
    public let avatarURL: URL?
    public let profileURL: URL?
    public let location: String
    public let followers: Int
    public let following: Int
    public let blog: String
    
    public init(
        name: String,
        avatarURL: URL?,
        profileURL: URL?,
        location: String = "",
        followers: Int = 0,
        following: Int = 0,
        blog: String = ""
    ) {
        self.id = UUID().uuidString
        self.name = name
        self.avatarURL = avatarURL
        self.profileURL = profileURL
        self.location = location
        self.followers = followers
        self.following = following
        self.blog = blog
    }
}
