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
                setIconViewImage(withIconName: iconStopped)
                if kDebugLog { print("View loaded") }
            }
        }
    }
    
    func switchIcon(_ playerState: FRadioPlayerState, _ playbackState: FRadioPlaybackState) {
        switch playerState {
        case .error:
            setIconViewImage(withIconName: iconError)
        case .loading:
            setIconViewImage(withIconName: iconLoading)
        case .loadingFinished, .readyToPlay:
            switch playbackState {
            case .paused, .stopped:
                setIconViewImage(withIconName: iconStopped)
            case .playing:
                setIconViewImage(withIconName: iconPlaying)
            }
        case .urlNotSet:
            setIconViewImage(withIconName: iconUrlNotSet)
        }
    }
    
    private func setIconViewImage(withIconName name: String) {
        if iconView != nil {
            iconView!.image = NSImage(named: name)
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
