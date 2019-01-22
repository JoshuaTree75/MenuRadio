//
//  NSSearchFieldDelegate.swift
//  MenuRadio
//
//  Created by Ken FUKUHARA on 21/01/2019.
//  Copyright © 2019 Ken FUKUHARA. All rights reserved.
//

import AppKit

extension PopoverViewController: NSSearchFieldDelegate {
    
    override func mouseEntered(with event: NSEvent) {
        if searchFieldConstraint.constant == searchWIdthClosed {
            expand(true)
        }
    }
    
    func expand(_ bool: Bool) {
        NSAnimationContext.runAnimationGroup({context in
            context.duration = 0.25
            context.allowsImplicitAnimation = true
            sortingSegmentedButton.isHidden = bool
            toolBarStackView.spacing = bool ? 2.0 : 4.0
            self.toolBarStackView.arrangedSubviews.last!.isHidden = bool ? true : false
            self.toolBarStackView.arrangedSubviews.last!.isHidden = bool ? true : false
            searchFieldConstraint.constant = bool ? searchWidthOpened : searchWIdthClosed
            searchField.isBezeled = bool
            searchField.bezelStyle = .roundedBezel
            self.view.layoutSubtreeIfNeeded()
        }, completionHandler: nil)
        view.window?.makeFirstResponder(nil)

       //        // searchField.layer?.opacity = bool ? 1 : 0
        //  searchFakeButton.isHidden = bool
        
        
    }
    
    override func mouseExited(with event: NSEvent) {
        if searchField.stringValue == "" {
            expand(false)
        }
        
    }
    override func mouseDown(with event: NSEvent) {
        view.window?.makeFirstResponder(nil)
    }
    
    func controlTextDidEndEditing(_ obj: Notification) {
        print("End editing")
    }
}
