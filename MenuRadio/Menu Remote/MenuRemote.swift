//
//  MenuRemote.swift
//  MenuRadio
//
//  Created by Ken FUKUHARA on 28/12/2018.
//  Copyright © 2018 Ken FUKUHARA. All rights reserved.
//

import AppKit

class MenuRemote: NSObject {
    
    //*****************************************************************
    // MARK: - Properties
    //*****************************************************************
        
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    
    var menuView: LongPressView?
        
     let prefs = PreferenceManager.shared
    
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
    
    let stationManager = StationManager()
    
    var stations = [RadioStation]() {
        didSet {
            guard stations != oldValue else { return }
            let dict = stations.sorted(by: {$0.name < $1.name})
            stations = dict
            self.prefs.stations = dict
            stationsDidUpdate()
            if kDebugLog { print("Stations list did update") }
        }
    }
    
    var selectedStation: RadioStation? {
        didSet {
            guard selectedStation != oldValue else { return }
            if selectedStation != nil {
                //                stationManager.station = selectedStation
                //                //prefs.selectedStationIndex = stations.index(of: selectedStation!)
                //                stationManager.player.radioURL = URL(string: selectedStation!.streamURL)
            }
        }
    }
    //*****************************************************************
    // MARK: - Initialization
    //*****************************************************************
    
    override init() {
        super.init()
        menuSetup()
        popoverSetup()
        stationsSetup()
    }
    
    func menuSetup() {
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
    
    func popoverSetup() {
        popoverController = PopoverViewController.freshController()
        popoverController!.delegate = self
        let _ = self.popoverController!.view // call viewDidLoad()
    }
    
    func stationsSetup() {
        stationManager.delegate = self
        stations = prefs.stations
        //selectedStation = stations[prefs.selectedStationIndex!]
        stationsDidUpdate()
    }
    
    //*****************************************************************
    // MARK: - Private helpers
    //*****************************************************************
    
    internal func stationsDidUpdate() {
        DispatchQueue.main.async {
            //Reload
        }
    }
    
    // Reset all properties to default
    func resetCurrentStation() {
        //deselect popUp
        //  self.popoverController!.stationPopup.select(nil)
        stationManager.resetRadioPlayer()
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
        switch stationManager.player.state {
        case .error, .urlNotSet:
            togglePopover(self)
        default:
            stationManager.player.togglePlaying()
        }
    }
    func longPress() {
        if kDebugLog { print("Mouse held") }
        if popover.isShown { return }
        showPopover(sender: nil)
    }
}

////*****************************************************************
//// MARK: - MenuRemoteDelegate
////*****************************************************************
//
//protocol MenuRemoteDelegate {
//    func menuWasClicked()
//    func menuWasHold()
//}
