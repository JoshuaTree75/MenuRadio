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
    
    var menuView: LongPressView?
    
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
                let buttonView = LongPressView()
                buttonView.frame = statusItem.button!.frame
                buttonView.delegate = self
                buttonView.imageNamePattern = iconStopped
                
                //let iconView = AnimatedView(imageNamePattern: iconStopped, imageCount: 12, frame: frame)
                
               // iconView.addSubview(buttonView)
                icon.addSubview(buttonView)
                menuView = buttonView
                
                //switchIcon(withImageNamed: iconStopped, animated: false)
                if kDebugLog { print("View loaded") }
            }
        }
    }
    
    func switchIcon(withImageNamed name: String, animated: Bool) {
        if menuView != nil {
            menuView?.imageNamePattern = name
            if animated {
                menuView?.startAnimating()
            } else {
                menuView?.stopAnimating()
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
