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
            if kDebugLog { print("Stations did update") }
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
            self.popoverController!.loadPopup(withStations: self.stations)

            guard let currentStation = self.stationManager.selectedStation else { return }
            
            // Reset everything if the new stations list doesn't have the current station
            if self.stations.index(of: currentStation) == nil {
                self.resetCurrentStation()
                if kDebugLog { print("Previous station lost")
                }
            }
            
        }
    }
    
    //*****************************************************************
    // MARK: - Segue
    //*****************************************************************
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard segue.identifier == "NowPlaying", let nowPlayingVC = segue.destination as? NowPlayingViewController else { return }
//
//        title = ""
//
//        let newStation: Bool
//
//        if let indexPath = (sender as? IndexPath) {
//            // User clicked on row, load/reset station
//            radioPlayer.station = searchController.isActive ? searchedStations[indexPath.row] : stations[indexPath.row]
//            newStation = true
//        } else {
//            // User clicked on Now Playing button
//            newStation = false
//        }
//
//        nowPlayingViewController = nowPlayingVC
//        nowPlayingVC.load(station: radioPlayer.station, track: radioPlayer.track, isNewStation: newStation)
//        nowPlayingVC.delegate = self
//    }
    
    // Reset all properties to default
    func resetCurrentStation() {
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
       
        stationManager.player.togglePlaying()
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
    func playerStateDidChange(_ playerState: FRadioPlayerState) {
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
        menuRemote.switchIcon(withImageNamed: imageName, animated: false)
    }
    
    func playbackStateDidChange(_ playbackState: FRadioPlaybackState) {
        
        var imageName: String

        switch playbackState {
        case .paused, .stopped:
            imageName = iconStopped
        case .playing:
            imageName = iconPlaying
        }
        menuRemote.switchIcon(withImageNamed: imageName, animated: false)
    }
    
    func trackDidUpdate(_ track: Track?) {
        
    }
    
    func trackArtworkDidUpdate(_ track: Track?) {
        
    }
    
}

//*****************************************************************

extension MenuRadioController: PopoverViewControllerDelegate {

    //*****************************************************************
    // MARK: - PopoverViewControllerDelegate
    //*****************************************************************

    func selectedStationDidChange() {
        
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