
import UIKit

final class MenuButton: Button {
    
    private let forCollectionView: Bool
    
    var showBackgroundClosure: BoolClosure?
    var hideBackgroundClosure: BoolClosure?

    init(forCollectionView: Bool) {
        self.forCollectionView = forCollectionView
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willEndFor configuration: UIContextMenuConfiguration, animator: (any UIContextMenuInteractionAnimating)?) {
        hideBackgroundClosure?(forCollectionView)
    }
    
    override func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willDisplayMenuFor configuration: UIContextMenuConfiguration, animator: (any UIContextMenuInteractionAnimating)?) {
        showBackgroundClosure?(forCollectionView)
    }
}
