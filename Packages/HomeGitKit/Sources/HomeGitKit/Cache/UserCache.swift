import Foundation
import PersistentStorages
import GlobalEntities

class UserCache {
    static let shared = UserCache()

    private let userCache = DiskCacheManager<[UserModel]>(fileName: "users.json")

    private init() {}

    // Save Users
    func saveUsers(_ users: [UserModel]) async {
        await userCache.save(users)
    }

    // Load Users
    func loadUsers() async -> [UserModel]? {
        await userCache.load()
    }
    
    // Clear
    func clearCache() async {
        await userCache.clearDisk()
    }
}
