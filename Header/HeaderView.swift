//
//  HeaderView.swift
//  Header
//
//  Created by Greg Spiers on 05/10/2017.
//  Copyright © 2017 BBC. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    @IBOutlet weak var headerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // ***************
    // Fix #1
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        // Uncomment below to work around bug of section header zindex not being correct:
        // This still has a flash as the section header is first displayed.
        // Real fix below by using hard coded zPosition from a layer subclass (yikes!)
        // https://openradar.appspot.com/34308893
        // https://openradar.appspot.com/34633539
        // https://openradar.appspot.com/34829104
        //self.layer.zPosition = CGFloat(layoutAttributes.zIndex)
    }

    // ***************
    // Fix #2
    // Uncomment this to fix by using a hardcoded zPosition for the layer.
//    override class var layerClass: AnyClass {
//        return FixLayer.self
//    }
}

// Really horrible work around for bugs above.
class FixLayer: CALayer {
    override var zPosition: CGFloat {
        get {
            return -1
        }
        set {
            // ignore
        }
    }
}
