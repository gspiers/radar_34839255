//
//  UICollectionViewLayoutAttributes+Copying.swift
//  Header
//
//  Created by Greg Spiers on 05/10/2017.
//  Copyright © 2017 BBC. All rights reserved.
//

import UIKit

extension Collection where Element: UICollectionViewLayoutAttributes {
    func copy<T: UICollectionViewLayoutAttributes>() -> [T] {
        return self.map { $0.copyAttributes() }
    }
}

extension UICollectionViewLayoutAttributes {
    func copyAttributes<T: UICollectionViewLayoutAttributes>() -> T {
        guard let copy = self.copy() as? T else {
            fatalError()
        }
        return copy
    }
}
