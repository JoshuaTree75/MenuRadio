//
//  MenuRadioController.swift
//  MenuRadio
//
//  Created by Ken FUKUHARA on 23/12/2018.
//  Copyright © 2018 Ken FUKUHARA. All rights reserved.
//

import Foundation
import AppKit

/**
 This class controls the others objects: Menu remote, station manager, FPlayerRadio, Popover.
 */
class MenuRadioController: NSObject {

    //*****************************************************************
    // MARK: - Properties
    //*****************************************************************

    var menuRemote = MenuRemote()
    
    lazy var popover: NSPopover = {
        let popover = NSPopover()
        popover.behavior = .transient
        popover.contentViewController = PopoverViewController.freshController()
        popover.delegate = self
        popover.animates = true
        return popover
    }()
    
    var popoverTransiencyMonitor: NSEvent?
    
    var stationManager = StationManager()
    
    //*****************************************************************
    // MARK: - Initialization
    //*****************************************************************

    override init() {
        super.init()
        menuRemote.delegate = self
    }
    
    //*****************************************************************
    // MARK: - Popover management
    //*****************************************************************
    

    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
            if kDebugLog { print("closePopover") }
        } else {
            showPopover(sender: sender)
            if kDebugLog { print("showPopover") }
        }
    }
    
    func showPopover(sender: Any?) {
        if let icon = menuRemote.iconView {
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

extension MenuRadioController: MenuRemoteDelegate {
    func menuWasClicked() {
        //        if kDebugLog { print(manager.player.playbackState.description) }
        //        if kDebugLog { print(manager.player.state.description) }
        togglePlayback()
    }
    
    func togglePlayback() {
        switch stationManager.player.playbackState {
        case .paused:
            stationManager.player.play()
        case .playing:
            stationManager.player.pause()
        case .stopped:
            switch stationManager.player.state {
            case .error, .urlNotSet:
                togglePopover(self)
            default:
                stationManager.player.play()
            }
        }
    }

    func menuWasHold() {
        if popover.isShown { return }
        showPopover(sender: nil)
    }
}


//*****************************************************************
// MARK: - StationManager delegation
//*****************************************************************

extension MenuRadioController: StationManagerDelegate {
    internal func stationsDidUpdate() {
            DispatchQueue.main.async {
                
                // self.tableView.reloadData()
                guard let currentStation = self.stationManager.selectedStation else { return }
                
                // Reset everything if the new stations list doesn't have the current station
                if self.stationManager.stations.index(of: currentStation) == nil { self.stationManager.resetCurrentStation() }
            }
    }
    
    func statesDidChange(_ playerState: FRadioPlayerState, _ playbackState: FRadioPlaybackState) {
        menuRemote.switchIcon(playerState, playbackState)
    }
    
    func trackDidUpdate(_ track: Track?) {
        
    }
    
    func trackArtworkDidUpdate(_ track: Track?) {
        
    }

}



//*****************************************************************
// MARK: - Popover delegation
//*****************************************************************

extension MenuRadioController: NSPopoverDelegate {
    
    func popoverShouldDetach(_ popover: NSPopover) -> Bool {
        return true
    }
    
    func detachableWindow(for popover: NSPopover) -> NSWindow? {
        //        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 0, height: 0), styleMask: [.resizable], backing: NSWindow.BackingStoreType.buffered, defer: true)
        //        window = popover.contentViewController
        return nil
        
    }
    
    func popoverDidShow(_ notification: Notification) {
        if kDebugLog { print("popover did show") }
        
    }
    
    func popoverDidDetach(_ popover: NSPopover) {
        if kDebugLog { print("popover did detach") }
        //        if let vc = (popover.contentViewController as? PopoverViewController) {
        //            vc.isExpanded = true
        //            if kDebugLog { print("vc.stackView: \(vc.stackView.subviews.description)") }
        //    }
    }
    
    func popoverDidClose(_ notification: Notification) {
        let closeReason = notification.userInfo![NSPopover.closeReasonUserInfoKey] as! String
        if (closeReason == NSPopover.CloseReason.standard.rawValue) {
            if kDebugLog { print("closeReason: popover did close") }
            //            if let vc = popover.contentViewController as? PopoverViewController {
            //                vc.isExpanded = false
            //                if kDebugLog { print("vc.stackView: \(vc.stackView.subviews.description)") }
            //    }
        }
        //Never called, don't know why -> popoverDidDetatch(:) used instead
        if (closeReason == NSPopover.CloseReason.detachToWindow.rawValue) {
            if kDebugLog { print("closeReason: popover did detach") }
        }
    }
}
