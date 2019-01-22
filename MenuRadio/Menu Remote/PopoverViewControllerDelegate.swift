//
//  PopoverViewControllerDelegate.swift
//  MenuRadio
//
//  Created by Ken FUKUHARA on 09/01/2019.
//  Copyright © 2019 Ken FUKUHARA. All rights reserved.
//

import Foundation
import AppKit

extension MenuRemote: PopoverViewControllerDelegate {
    
    //*****************************************************************
    // MARK: - PopoverViewControllerDelegate
    //*****************************************************************
    
    func selectedStationDidChange() {
        if kDebugLog { print("selectedStationDidChange") }
       // if let index = popoverController?.stationPopup.indexOfSelectedItem {
      //  stationManager.station = selectedStation
        //prefs.selectedStationIndex = stations.index(of: selectedStation!)
        if let stream = prefs.selectedStation?.streamURL {
            stationManager.player.radioURL = URL(string: stream)
        }
         //   if !popover.isDetached { closePopover(sender: self) }
       // }
    }
    
//    func stationsDidChange() {
//        PreferenceManager.shared.stations = stations
//    }
    
    func didPickPreference(menuItem: NSMenuItem) {
        var newState: Bool
        
        if menuItem.state == .on {
            menuItem.state = .off
            newState = false
        } else {
            menuItem.state = .on
            newState = true
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
            switchIcon(withImageNamed: iconNameForStates(stationManager.player.state, stationManager.player.playbackState), animated: newState)
        default:
            if kDebugLog { print("This menu dosen't exist")}
        }
    }
    
    func getStationsForCollectionView() -> [RadioStation] {
        return prefs.stations
    }
}
