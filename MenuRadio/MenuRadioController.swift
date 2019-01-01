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
            self.prefs.stations = self.stations
            stationsDidUpdate()
            if kDebugLog { print("Stations list did update") }
        }
    }
    
    var selectedStation: RadioStation? {
        didSet {
            guard selectedStation != oldValue else { return }
            if selectedStation != nil {
                stationManager.station = selectedStation
                prefs.selectedStation = selectedStation
                stationManager.player.radioURL = URL(string: selectedStation!.streamURL)
            }
        }
    }
    
    //*****************************************************************
    // MARK: - Preferences management
    //*****************************************************************
    
    let prefs = PreferenceManager()

    
    //*****************************************************************
    // MARK: - Initialization
    //*****************************************************************
    
    override init() {
        super.init()
        menuRemote.delegate = self
        popoverController = PopoverViewController.freshController()
        popoverController!.delegate = self
        let _ = self.popoverController!.view // call the viewDidLoad() method
        stationManager.delegate = self
        stations = prefs.stations
        stationsDidUpdate()
        selectedStation = prefs.selectedStation
        stationManager.station = selectedStation
    }
    
    //*****************************************************************
    // MARK: - Private helpers
    //*****************************************************************
    
    internal func stationsDidUpdate() {
        DispatchQueue.main.async {
            //Refressh popover
            self.popoverController!.refreshPopup(withStations: self.stations)

            guard let currentStation = self.prefs.selectedStation else {
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

}

//*****************************************************************
// MARK: - Menu Remote delegation
//*****************************************************************

extension MenuRadioController: MenuRemoteDelegate {
    func menuWasClicked() {
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
            selectedStation = stations[index]
            if !popover.isDetached { closePopover(sender: self) }
        }
    }
    
    func didPickPreference(menuItem: NSMenuItem) {
        var newState: Bool
        
        if menuItem.state == .on {
            menuItem.state = .off
            newState = false
        } else {
            menuItem.state = .on
            newState = false
        }
        
        switch menuItem.title {
        case menuLaunchAtStartup:
            prefs.launchAtStartup = newState
        case menuAutoPlay:
            prefs.autoplay = newState
        case menuNotifications:
            prefs.notifications = newState
        case menuAnimatedIcon:
            prefs.animatedIcon = newState
        default:
            if kDebugLog { print("This menu dosen't exist")}
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
//        let translucentView = NSVisualEffectView(frame: <#T##NSRect#>)
//       let panel = NSPanel(contentRect: NSRect(x: 0, y: 0, width: 300, height: 300), styleMask: [.resizable, .closable, .titled], backing: NSWindow.BackingStoreType.buffered, defer: true)
//       panel.contentViewController = popover.contentViewController
        return nil
        
    }
    
    func popoverDidShow(_ notification: Notification) {
        if kDebugLog { print("popover did show") }
        
    }
    
    func popoverDidDetach(_ popover: NSPopover) {
        if kDebugLog { print("popover did detach") }
        if let vc = (popover.contentViewController as? PopoverViewController) {
            vc.isExpanded = true
            print("vc.stackView: \(vc.stackView.subviews.description)")
        }
    }
    
    func popoverDidClose(_ notification: Notification) {
        let closeReason = notification.userInfo![NSPopover.closeReasonUserInfoKey] as! String
        if (closeReason == NSPopover.CloseReason.standard.rawValue) {
            if kDebugLog { print("closeReason: popover did close") }
            if let vc = popover.contentViewController as? PopoverViewController {
                vc.isExpanded = false
                if kDebugLog { print("vc.stackView: \(vc.stackView.subviews.description)") }
            }
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
