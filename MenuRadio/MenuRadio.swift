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
                icon = NSImage(named: NSImage.Name("iconError"))!
            case .Playing:
                icon = NSImage(named: NSImage.Name("iconPlaying"))!
            case .Stop:
                icon = NSImage(named: NSImage.Name("iconStop"))!
            case .UrlNotSet:
                icon = NSImage(named: NSImage.Name("iconUrlNotSet"))!
            case .Loading:
                icon = NSImage(named: NSImage.Name("iconUrlNotSet"))!
            }
        }
    }
    
    // MARK: - Managing the icon
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    
    var icon = NSImage() {
        didSet {
            if let view = statusItem.button?.subviews.last as? LongPressButton {
            view.image = icon
            }
        }
    }
    
    func launch() {
        if let menuIcon = statusItem.button {
            if statusItem.button?.subviews.count == 0 {
                let frame = statusItem.button!.frame
                let view = LongPressButton.init(frame: frame)
                view.imageScaling = .scaleProportionallyUpOrDown
                view.delegate = self
                menuIcon.addSubview(view)
                print("IconView loaded")
                playbackState = .Stop
            }
        }
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
