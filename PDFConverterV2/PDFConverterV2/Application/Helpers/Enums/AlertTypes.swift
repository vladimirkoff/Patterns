
import UIKit

enum AlertTypes {
    
    case delete
    case pdfReady
    case sizeExceeded
    case noFiles
    
    var title: String {
        switch self {
        case .delete:
            R.string.localizable.alertDeleteTitle()
        case .pdfReady:
            R.string.localizable.alertPdfPreviewTitle()
        case .sizeExceeded:
            "Allowed file size exceeded"
        case .noFiles:
            "There’s nothing here yet"
        }
    }
    
    var subtitle: String {
        switch self {
        case .delete, .pdfReady:
                .empty
        case .sizeExceeded:
            "The size of the selected files\n exceeds 16 MB"
        case .noFiles:
            "Click “+” to convert your files to PDF"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .delete:
            R.image.images.components.bin()
        case .pdfReady:
            R.image.images.application.pdf()
        case .sizeExceeded:
            R.image.images.application.error()
        case .noFiles:
            R.image.images.application.pdf()
        }
    }
    
    var selectedButtonTitle: String {
        switch self {
        case .delete:
            R.string.localizable.alertDeleteSelectedButton()
        case .pdfReady, .sizeExceeded:
            R.string.localizable.alertPdfPreviewSelectedButton()
        case .noFiles:
            .empty
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .delete:
            R.string.localizable.alertDeleteButton()
        case .pdfReady:
            R.string.localizable.alertPdfPreviewButon()
        case .sizeExceeded:
            .empty
        case .noFiles:
            .empty
        }
    }
}
