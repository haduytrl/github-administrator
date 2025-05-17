import Foundation

public actor DiskCacheManager<T: Codable> {
    private let fileManager = FileManager.default
    private let fileName: String

    public init(fileName: String) {
        self.fileName = fileName
    }

    // MARK: - Save Data to Cache
    public func save(_ data: T) {
        guard let encodedData = encode(data: data) else { return }
        let url = getFileURL()
        try? encodedData.write(to: url)
    }

    // MARK: - Load Data from Cache
    public func load() -> T? {
        guard let diskData = loadFromDisk() else { return nil }
        return decode(data: diskData)
    }
    
    // MARK: - Clear Cache
    public func clearDisk() {
        let fileURL = getFileURL()
        
        guard fileManager.fileExists(atPath: fileURL.path) else { return }
        do {
            try fileManager.removeItem(at: fileURL)
            debugPrint("Disk file was removed successfully")
        } catch {
            print("Error when clearing disk: \(error.localizedDescription)")
        }
    }

    // MARK: - Helper Methods

    private func loadFromDisk() -> Data? {
        let url = getFileURL()
        return try? Data(contentsOf: url)
    }

    private func getFileURL() -> URL {
        let documentDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDir.appendingPathComponent(fileName)
    }
    
    private func encode(data: T) -> Data? {
        return try? JSONEncoder().encode(data)
    }

    private func decode(data: Data) -> T? {
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
