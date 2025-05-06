//
//  PlusButton.swift
//  PDFConverterV2
//
//  Created by Кирилл Жогальский on 28.03.24.
//

import UIKit

final class PlusButton: Button {
    
    var showBackgroundClosure: VoidClosure?
    var hideBackgroundClosure: VoidClosure?
    
    override func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willEndFor configuration: UIContextMenuConfiguration, animator: (any UIContextMenuInteractionAnimating)?) {
        hideBackgroundClosure?()
    }
    
    override func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willDisplayMenuFor configuration: UIContextMenuConfiguration, animator: (any UIContextMenuInteractionAnimating)?) {
        showBackgroundClosure?()
    }
}
