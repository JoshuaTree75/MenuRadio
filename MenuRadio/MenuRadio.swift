//
//  MenuRadio.swift
//  MenuRadio
//
//  Created by Ken FUKUHARA on 23/12/2018.
//  Copyright © 2018 Ken FUKUHARA. All rights reserved.
//

import Foundation
import AppKit

/**
 This class manages the app. It handles the icon menu behaviour and appareance
 */
class MenuRadio: LongPressButtonDelegate {
    
    // MARK: - Properties
    
    var playbackState: MenuRadioPlaybackState = .Stop {
        didSet {
            print("Playback state is: \(playbackState)")
            switch playbackState {
            case .Error:
                setMenuIcon(withIconName: "iconError")
            case .Playing:
                setMenuIcon(withIconName: "iconPlaying")
            case .Stop:
                setMenuIcon(withIconName: "iconStop")
            case .UrlNotSet:
                setMenuIcon(withIconName: "iconUrlNotSet")
            case .Loading:
                setMenuIcon(withIconName: "iconLoading")
            }
        }
    }

    // MARK: - Managing the icon
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    
    var iconView: LongPressButton?
    
    func launch() {
        if let menuIcon = statusItem.button {
            if statusItem.button?.subviews.count == 0 {
                let frame = statusItem.button!.frame
                let view = LongPressButton.init(frame: frame)
                view.delegate = self
                menuIcon.addSubview(view)
                iconView = view
                print("IconView loaded")
                playbackState = .Stop
            }
        }
    }
    
    func setMenuIcon(withIconName name: String) {
        iconView?.image = NSImage(named: name)
    }
    
    // MARK: - Managing the menu button
    func click() {
          print("Mouse clicked")
        switch playbackState {
        case .Error:
            playbackState = .Playing
            longPress()
        case .Playing:
            playbackState = .Stop
        case .Stop:
            playbackState = .UrlNotSet
        case .UrlNotSet:
            longPress()
            playbackState = .Error
        case .Loading:
            playbackState = .Stop
        }
    }

    // MARK: - Managing the popover
    func longPress() {
        print("Mouse held")
    }

}
