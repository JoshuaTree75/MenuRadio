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
        popover.contentViewController = popoverController
        popover.delegate = self
        popover.animates = true
        return popover
    }()
    
    var popoverTransiencyMonitor: NSEvent?
    
    var popoverController: PopoverViewController?
    
    var stationManager = StationManager()
    
    var stations = [RadioStation]() {
        didSet {
            guard stations != oldValue else { return }
            stationsDidUpdate()
            if kDebugLog { print("Stations list did update") }
        }
    }
    
    //*****************************************************************
    // MARK: - Initialization
    //*****************************************************************
    
    override init() {
        super.init()
        menuRemote.delegate = self
        popoverController = PopoverViewController.freshController()
        popoverController!.delegate = self
        stationManager.delegate = self
        loadStationsFromJSON()
    }
    
    //*****************************************************************
    // MARK: - Private helpers
    //*****************************************************************
    
    internal func changeToStation(_ station: RadioStation) {
        
    }
    
    internal func stationsDidUpdate() {
        DispatchQueue.main.async {
            let _ = self.popoverController!.view
            self.popoverController!.refreshPopup(withStations: self.stations)

            guard let currentStation = self.stationManager.station else {
                // No station selected
                return
            }
            
            // Reset everything if the new stations list doesn't have the current station
            if self.stations.index(of: currentStation) == nil {
                self.resetCurrentStation()
                if kDebugLog { print("Previous station lost. None selected") }
            } else {
                self.popoverController!.selectedStation = currentStation
                if kDebugLog { print("Station selected in Popup") }
            }
        }
    }
    
    
    
    // Reset all properties to default
    func resetCurrentStation() {
        //deselect popUp
        self.popoverController!.stationPopup.select(nil)
        stationManager.resetRadioPlayer()
    }
    
    func loadStationsFromJSON(){
        // Get the Radio Stations
        DataManager.getStationDataWithSuccess() { (data) in
            
            if kDebugLog { print("Stations JSON Found") }
            
            guard let data = data, let jsonDictionary = try? JSONDecoder().decode([String: [RadioStation]].self, from: data), let stationsArray = jsonDictionary["station"] else {
                if kDebugLog { print("JSON Station Loading Error") }
                return
            }
            
            self.stations = stationsArray
        }
    }

    
    //*****************************************************************
    // MARK: - Preferences management
    //*****************************************************************
    
    let preferences = PreferenceManager()
}

//*****************************************************************
// MARK: - Menu Radio delegation
//*****************************************************************

extension MenuRadioController: MenuRemoteDelegate {
    func menuWasClicked() {
        //        if kDebugLog { print(manager.player.playbackState.description) }
        //        if kDebugLog { print(manager.player.state.description) }
        switch stationManager.player.state {
        case .error, .urlNotSet:
            togglePopover(self)
        default:
            stationManager.player.togglePlaying()
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
    
    func iconNameForStates(_ playerState: FRadioPlayerState, _ playbackState: FRadioPlaybackState) -> String {
        var imageName: String
        
        switch playerState {
        case .error:
            imageName = iconError
        case .loading:
            imageName = iconLoading
        case .loadingFinished, .readyToPlay:
            switch stationManager.player.playbackState {
            case .playing:
                imageName = iconPlaying
            case .paused, .stopped:
                imageName = iconStopped
            }
        case .urlNotSet:
            imageName = iconUrlNotSet
        }
        
        return imageName
    }
    
    func playerStateDidChange(_ playerState: FRadioPlayerState) {
        
        let iconName = iconNameForStates(playerState, stationManager.player.playbackState)
        menuRemote.switchIcon(withImageNamed: iconName, animated: false)
    }
    
    func playbackStateDidChange(_ playbackState: FRadioPlaybackState) {
        
        let iconName = iconNameForStates(stationManager.player.state, playbackState)
        menuRemote.switchIcon(withImageNamed: iconName, animated: false)
    }
    
    func trackDidUpdate(_ track: Track?) {
        popoverController?.updateTrack(track)
    }
    
    func trackArtworkDidUpdate(_ track: Track?) {
        popoverController?.updateTrackArtwork(track)

    }
    
}

//*****************************************************************

extension MenuRadioController: PopoverViewControllerDelegate {

    //*****************************************************************
    // MARK: - PopoverViewControllerDelegate
    //*****************************************************************

    func selectedStationDidChange() {
        if kDebugLog { print("selectedStationDidChange") }
        if let index = popoverController?.stationPopup.indexOfSelectedItem {
            stationManager.station = stations[index]
            stationManager.player.radioURL = URL(string: stationManager.station!.streamURL)
            if !popover.isDetached { closePopover(sender: self) }
        }
    }
}


extension MenuRadioController: NSPopoverDelegate {
    
    //*****************************************************************
    // MARK: - Popover delegation
    //*****************************************************************

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
    
}
