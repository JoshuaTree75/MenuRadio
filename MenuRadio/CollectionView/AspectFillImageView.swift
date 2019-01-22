//
//  AspectFillImageView.swift
//  MenuRadio
//
//  Created by Ken FUKUHARA on 16/01/2019.
//  Copyright © 2019 Ken FUKUHARA. All rights reserved.
//

import Cocoa
import QuartzCore

class AspectFillImageView: NSImageView {
    
    
    open override var image: NSImage? {
        set {
            self.layer = CALayer()
            self.layer?.contentsGravity = CALayerContentsGravity.resizeAspectFill
            self.layer?.contents = newValue
            self.wantsLayer = true
            
            super.image = newValue
        }
        
        get {
            return super.image
        }
    }
}

