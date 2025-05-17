import Foundation
import UIKit

public enum AppSpacing: CGFloat {
    case extraLarge = 34
    case large = 26
    case xlarge = 24
    case mediumLarge = 20
    case medium = 16
    case xmedium = 12
    case small = 8
    case xssmall = 6
    case xsmall = 4
    case xxsmall = 2
}

public enum AppRadius: CGFloat {
    case xl = 44
    case lg = 32
    case mlg = 24
    case md = 16
    case sm = 8
    case xs = 4
}

public extension CGFloat {
    static func getCornerRadius(_ value: AppRadius) -> CGFloat {
        return value.rawValue
    }
    
    static func getSpacing(_ value: AppSpacing) -> CGFloat {
        return value.rawValue
    }
    
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
}
