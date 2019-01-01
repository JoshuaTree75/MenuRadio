//
//  MenuRemote.swift
//  MenuRadio
//
//  Created by Ken FUKUHARA on 28/12/2018.
//  Copyright © 2018 Ken FUKUHARA. All rights reserved.
//

import Cocoa

class MenuRemote: NSObject {
    
    //*****************************************************************
    // MARK: - Properties
    //*****************************************************************
    
    var delegate: MenuRemoteDelegate?
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    
    var iconView: LongPressView?
    
    //*****************************************************************
    // MARK: - Initialization (Menu creation)
    //*****************************************************************
    
    override init() {
        super.init()
        addMenuView()
    }
    
    func addMenuView() {
        if let icon = statusItem.button {
            if statusItem.button?.subviews.count == 0 {
                let frame = statusItem.button!.frame
                
                let view = LongPressView.init(frame: frame)
                view.delegate = self
                icon.addSubview(view)
                iconView = view
                switchIcon(withImageNamed: iconStopped, animated: false)
                if kDebugLog { print("View loaded") }
            }
        }
    }
    func switchIcon(withImageNamed name: String, animated: Bool) {
        if animated {
            
        } else {
            if iconView != nil {
                iconView!.image = NSImage(named: name)
            }
        }
    }
}

//*****************************************************************
// MARK: - LongPressViewDelegate
//*****************************************************************

extension MenuRemote: LongPressViewDelegate {
    
    func click() {
        if kDebugLog { print("Mouse clicked") }
        delegate?.menuWasClicked()
    }
    func longPress() {
        if kDebugLog { print("Mouse held") }
        delegate?.menuWasHold()
    }
}

//*****************************************************************
// MARK: - MenuRemoteDelegate
//*****************************************************************

protocol MenuRemoteDelegate {
    func menuWasClicked()
    func menuWasHold()
}
