//
//  HeaderView.swift
//  MenuRadio
//
//  Created by Ken FUKUHARA on 11/01/2019.
//  Copyright © 2019 Ken FUKUHARA. All rights reserved.
//

import Cocoa

class HeaderView: NSView {
    
    @IBOutlet weak var groupLabel: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor.textBackgroundColor.set()
        //NSColor(calibratedWhite: 0.8 , alpha: 0.0).set()
        __NSRectFillUsingOperation(dirtyRect, NSCompositingOperation.sourceOver)
    }
    
}
