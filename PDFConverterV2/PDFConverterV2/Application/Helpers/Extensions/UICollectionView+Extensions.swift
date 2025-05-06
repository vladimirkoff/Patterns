//
//  UICollectionView+Extensions.swift
//

import Foundation
import UIKit

extension UICollectionView {
    func register(_ cell: UICollectionViewCell.Type) {
        register(cell.self, forCellWithReuseIdentifier: cell.reuseIdentifier)
    }

    func register(_ view: UICollectionReusableView.Type, _ forSupplementaryViewOfKind: String) {
        register(view,
                 forSupplementaryViewOfKind: forSupplementaryViewOfKind,
                 withReuseIdentifier: view.reuseIdentifier)
    }
}

// MARK: - UICollectionReusableView
extension UICollectionReusableView {
    static var reuseIdentifier: String { return String(describing: self) }
}

extension UICollectionView {
    func scrollToNearestVisibleCollectionViewCell() {
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<self.visibleCells.count {
            let cell = self.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)

            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = self.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}
