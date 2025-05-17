import Foundation

enum Environment {
    case development
    case uat
    case production
}

extension Environment {
    struct Config {
        static let environment: Environment = .production
        static var baseURL: String {
            switch environment {
            case .production:
                return "https://api.github.com"
            case .development:
                return ""
            case .uat:
                return ""
            }
        }
        
        static var defaultHeaders: [String: String] {
            [
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }
}
