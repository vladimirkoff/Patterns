
import UIKit

enum ApphudError {
    case restore
    case purchase
    
    var title: String {
        R.string.localizable.errorAlertTitle()
    }
    
    var subtitle: String {
        switch self {
        case .restore:
            R.string.localizable.errorAlertRestoreSubtitle()
        case .purchase:
            R.string.localizable.errorAlertPurchaseSubtitle()
        }
    }
}

extension UIAlertController {
    static func createErrorAlert(error: ApphudError,
                                 tryAgainCompletion: @escaping(UIAlertAction) -> (),
                                 cancelCompletion: @escaping(UIAlertAction) -> ()
    ) -> UIAlertController {
        let alert = UIAlertController(title: error.title, message: error.subtitle, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: R.string.localizable.errorAlertCancel(), style: .cancel, handler: cancelCompletion)
        let tryAgainAction = UIAlertAction(title: R.string.localizable.errorAlertTryAgain(), style: .default, handler: tryAgainCompletion)
        
        alert.addAction(cancelAction)
        alert.addAction(tryAgainAction)
        return alert
    }
}
