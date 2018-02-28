//
//  HeaderFlowLayout.swift
//  Header
//
//  Created by Greg Spiers on 05/10/2017.
//  Copyright © 2017 BBC. All rights reserved.
//

import UIKit

class HeaderFlowLayout: UICollectionViewFlowLayout {

    var firstHeaderSize: CGSize?
    
    override func prepare() {
        super.prepare()
        firstHeaderSize = layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: IndexPath(row: 0, section: 0))?.size
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let oldBounds = collectionView?.bounds else {
            return super.shouldInvalidateLayout(forBoundsChange: newBounds)
        }
        guard let firstHeaderSize = firstHeaderSize else {
            return super.shouldInvalidateLayout(forBoundsChange: newBounds)
        }
        
        // Invalid if the old bounds was in range, or the new bounds is.
        if oldBounds.origin.y <= firstHeaderSize.height || newBounds.origin.y <= firstHeaderSize.height {
            return true
        }
        return super.shouldInvalidateLayout(forBoundsChange: newBounds)
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        // If we scroll past the top we only invalid the first header
        let context = super.invalidationContext(forBoundsChange: newBounds)
        if let firstHeaderSize = firstHeaderSize, newBounds.origin.y <= firstHeaderSize.height {
            let headerIndexPath = IndexPath(row: 0, section: 0)
            context.invalidateSupplementaryElements(ofKind: UICollectionElementKindSectionHeader, at: [headerIndexPath])
        }
        
        return context
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let allAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        
        var allAdjustedAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in allAttributes {
            if attributes.representedElementKind == UICollectionElementKindSectionHeader && attributes.indexPath == IndexPath(row: 0, section: 0) {
                let adjustedAttributes = adjustHeaderAttributesIfRequired(attributes: attributes)
                allAdjustedAttributes.append(adjustedAttributes)
            } else {
                let copiedAttributes = attributes.copyAttributes()
                allAdjustedAttributes.append(copiedAttributes)
            }
        }
        
        return allAdjustedAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) else { return nil }
        let copiedAttributes = attributes.copyAttributes()
        return copiedAttributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) else { return nil }
        return adjustHeaderAttributesIfRequired(attributes: attributes)
    }
    
    private func adjustHeaderAttributesIfRequired(attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = collectionView else { return attributes }
        guard let firstHeaderSize = firstHeaderSize else { return attributes }
        
        let copiedAttributes = attributes.copyAttributes()
        let offsetY = collectionView.bounds.origin.y
        
        // header is always behind other cells
        copiedAttributes.zIndex = -1
        
        // We are trying to scroll past the top, grow the image
        if offsetY < 0 {
            copiedAttributes.frame.origin.y = offsetY
            copiedAttributes.frame.size.height += -offsetY
        } else if offsetY <= firstHeaderSize.height {
            // Move at half the speed for parallex effect
            let newOrigin = (offsetY / firstHeaderSize.height) * 0.5 * firstHeaderSize.height
            copiedAttributes.frame.origin.y = newOrigin
        } else {
            return copiedAttributes
        }
        
        return copiedAttributes
    }
}
