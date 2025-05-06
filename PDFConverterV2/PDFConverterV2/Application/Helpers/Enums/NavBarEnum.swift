
import UIKit

enum NavBarEnum: CaseIterable {
    
    case main
    case settings
    case premium
    case scanner
    case photoPDF
    case filePDF
    
    var hasRightButton: Bool {
        switch self {
        case .settings, .premium, .filePDF:
            true
        default:
            false
        }
    }
    
    var hasLeftButton: Bool {
        switch self {
        case .main:
            false
        default:
            true
        }
    }
    
    var rightButtonImage: UIImage? {
        switch self {
        case .main:
            R.image.images.application.settings()
        case .settings, .premium, .filePDF:
            nil
        case .scanner, .photoPDF:
            R.image.images.components.add()
        }
    }
    
    var title: String {
        switch self {
        case .main:
            R.string.localizable.applicationScreenTitle()
        case .settings:
            R.string.localizable.settingsScreenTitle()
        case .premium:
            R.string.localizable.premiumScreenTitle()
        case .scanner:
            R.string.localizable.scannerScreenTitle()
        case .photoPDF:
            R.string.localizable.photoToPDFTitle()
        case .filePDF:
            R.string.localizable.fileToPDFTitle()
        }
    }
}
