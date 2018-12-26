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
class MenuRadio: NSObject {
    
    
    //*****************************************************************
    // MARK: - Properties
    //*****************************************************************
    
    let player = FRadioPlayer.shared
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    
    var iconView: LongPressButton?

    //*****************************************************************
    // MARK: - Initialization (Menu creation)
    //*****************************************************************
    
    override func awakeFromNib() {
        if let icon = statusItem.button {
            if statusItem.button?.subviews.count == 0 {
                let frame = statusItem.button!.frame
                let view = LongPressButton.init(frame: frame)
                view.delegate = self
                icon.addSubview(view)
                iconView = view
                print("View loaded")
            }
        }
        player.delegate = self
        player.radioURL = URL(string: "https://zzzzzpeacefulpiano.stream.publicradio.org/peacefulpiano.mp3")
    }
    
    //*****************************************************************
    // MARK: - Popover management
    //*****************************************************************
    
    
    lazy var popover: NSPopover = {
        let popover = NSPopover()
        popover.behavior = .transient
        popover.contentViewController = PopoverViewController.freshController()
        popover.delegate = self
        popover.animates = true
        return popover
    }()
    
    var popoverTransiencyMonitor: NSEvent?
    
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
            print("closePopover")
        } else {
            showPopover(sender: sender)
            print("showPopover")
        }
    }
    
    func showPopover(sender: Any?) {
        if let icon = statusItem.button {
            popover.show(relativeTo: icon.bounds, of: icon, preferredEdge: NSRectEdge.minY)
            if (popoverTransiencyMonitor == nil)
            {
                popoverTransiencyMonitor = NSEvent.addGlobalMonitorForEvents(matching: [NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.rightMouseDown], handler: {event in
                    self.closePopover(sender: sender)
                }) as? NSEvent
            }
        }
    }
    
    func closePopover(sender: Any?) {
        if popoverTransiencyMonitor != nil {
            NSEvent.removeMonitor(popoverTransiencyMonitor!)
            popoverTransiencyMonitor = nil;
        }
        popover.performClose(sender)
        
    }
    
    //*****************************************************************
    // MARK: - Preferences management
    //*****************************************************************
    
    let preferences = PreferenceManager()
}

//*****************************************************************
// MARK: - Menu button delegation
//*****************************************************************

extension MenuRadio: LongPressButtonDelegate {
    
    func click() {
        print("Mouse clicked")
        togglePlayback()
        
    }
    
    func togglePlayback() {
        switch player.playbackState {
        case .paused:
            player.play()
        case .playing:
            player.pause()
        case .stopped:
            player.play()
        }
    }
    
    func longPress() {
        print("Mouse held")
        togglePopover(self)
    }
}
//*****************************************************************
// MARK: - Popover delegation
//*****************************************************************

extension MenuRadio: NSPopoverDelegate {
    
    func popoverShouldDetach(_ popover: NSPopover) -> Bool {
        return true
    }
    
    func detachableWindow(for popover: NSPopover) -> NSWindow? {
        //        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 0, height: 0), styleMask: [.resizable], backing: NSWindow.BackingStoreType.buffered, defer: true)
        //        window = popover.contentViewController
        return nil
        
    }
    
    func popoverDidShow(_ notification: Notification) {
        print("popover did show")
        
    }
    
    func popoverDidDetach(_ popover: NSPopover) {
        print("popover did detach")
        //        if let vc = (popover.contentViewController as? PopoverViewController) {
        //            vc.isExpanded = true
        //            print("vc.stackView: \(vc.stackView.subviews.description)")
        //    }
    }
    
    func popoverDidClose(_ notification: Notification) {
        let closeReason = notification.userInfo![NSPopover.closeReasonUserInfoKey] as! String
        if (closeReason == NSPopover.CloseReason.standard.rawValue) {
            print("closeReason: popover did close")
            //            if let vc = popover.contentViewController as? PopoverViewController {
            //                vc.isExpanded = false
            //                print("vc.stackView: \(vc.stackView.subviews.description)")
            //    }
        }
        //Never called, don't know why -> popoverDidDetatch(:) used instead
        if (closeReason == NSPopover.CloseReason.detachToWindow.rawValue) {
            print("closeReason: popover did detach")
        }
    }
}

//*****************************************************************
// MARK: - FRadiostation delegation
//*****************************************************************

extension MenuRadio: FRadioPlayerDelegate {
    func radioPlayer(_ player: FRadioPlayer, playerStateDidChange state: FRadioPlayerState) {
        switch state {
        case .error:
            setIconViewImage(withIconName: "iconError")
            
        case .loading:
            setIconViewImage(withIconName: "iconLoading")
            
        case .loadingFinished, .readyToPlay:
            switch player.playbackState {
            case .paused, .stopped:
                setIconViewImage(withIconName: "iconStop")
                
            case .playing:
                setIconViewImage(withIconName: "iconPlaying")
            }
            
        case .urlNotSet:
            setIconViewImage(withIconName: "iconUrlNotSet")
        }
        
    }
    
    func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlaybackState) {
        switch state {
        case .paused, .stopped:
            setIconViewImage(withIconName: "iconStop")
            
        case .playing:
            setIconViewImage(withIconName: "iconPlaying")
        }
    }
    
    func setIconViewImage(withIconName name: String) {
        iconView?.image = NSImage(named: name)
    }

}
