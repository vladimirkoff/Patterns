
import UIKit

extension UIMenu {
    static func createAddMenu(
        scannerAction: @escaping(VoidClosure),
        galleryAction: @escaping(VoidClosure),
        filesAction: @escaping(VoidClosure)
    ) -> UIMenu {
        let scanner = UIAction(title: R.string.localizable.menuScanner(), image: R.image.images.application.scanner(), attributes: []) { (_) in
            scannerAction()
        }
        
        let gallery = UIAction(title: R.string.localizable.menuGallery(), image: R.image.images.application.gallery()) { (_) in
            galleryAction()
         }
        
        let files = UIAction(title: R.string.localizable.menuFiles(), image: R.image.images.application.imporFiles()) { (_) in
           filesAction()
         }

        let menu = UIMenu(title: .empty, children: [files, gallery, scanner])
        return menu
    }
    
    static func createEditMenu(
        shareAction: @escaping(VoidClosure),
        deleteAction: @escaping(VoidClosure)
    ) -> UIMenu {
        
        let share = UIAction(title: R.string.localizable.menuShare(), image: R.image.images.settings.share()) { (_) in
            shareAction()
         }
        
        let delete = UIAction(title: R.string.localizable.menuDelete(), image: R.image.images.application.delete()) { (_) in
           deleteAction()
         }

        let menu = UIMenu(title: .empty, children: [share, delete])
        return menu
    }
}
