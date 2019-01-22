////
////  MenuRadioController.swift
////  MenuRadio
////
////  Created by Ken FUKUHARA on 23/12/2018.
////  Copyright © 2018 Ken FUKUHARA. All rights reserved.
////
//
//import Foundation
//import AppKit
//
///**
// This class controls the others objects: Menu remote, station manager, FPlayerRadio, Popover.
// */
//class MenuRadioController: NSObject {
//    
//    //*****************************************************************
//    // MARK: - Properties
//    //*****************************************************************
//    
//    let menuRemote = MenuRemote()
//    
//    lazy var popover: NSPopover = {
//        let popover = NSPopover()
//        popover.behavior = .transient
//        popover.contentViewController = popoverController
//        popover.delegate = self
//        popover.animates = true
//        return popover
//    }()
//    
//    var popoverTransiencyMonitor: NSEvent?
//    
//    var popoverController: PopoverViewController?
//    
//    let stationManager = StationManager()
//    
//    var stations = [RadioStation]() {
//        didSet {
//            guard stations != oldValue else { return }
//            let dict = stations.sorted(by: {$0.name < $1.name})
//            stations = dict
//            self.prefs.stations = dict
//            stationsDidUpdate()
//            if kDebugLog { print("Stations list did update") }
//        }
//    }
//    
//    var selectedStation: RadioStation? {
//        didSet {
//            guard selectedStation != oldValue else { return }
//            if selectedStation != nil {
////                stationManager.station = selectedStation
////                //prefs.selectedStationIndex = stations.index(of: selectedStation!)
////                stationManager.player.radioURL = URL(string: selectedStation!.streamURL)
//            }
//        }
//    }
//    
//    //*****************************************************************
//    // MARK: - Preferences management
//    //*****************************************************************
//    
//    let prefs = PreferenceManager.shared
//    
//    //*****************************************************************
//    // MARK: - Initialization
//    //*****************************************************************
//    
//    override init() {
//        super.init()
//        menuRemote.delegate = self
//        popoverController = PopoverViewController.freshController()
//        popoverController!.delegate = self
//        let _ = self.popoverController!.view // call viewDidLoad()
//        stationManager.delegate = self
//        stations = prefs.stations
//        //selectedStation = stations[prefs.selectedStationIndex!]
//        stationsDidUpdate()
//    }
//    
//    //*****************************************************************
//    // MARK: - Private helpers
//    //*****************************************************************
//    
//    internal func stationsDidUpdate() {
//        DispatchQueue.main.async {
//            //Refressh popover
//           // self.popoverController!.refreshPopup(withStationsIn: self.stations)
//            //self.popoverController!.radioListTableView.reloadData()
//            
//            //A station is selected
////            if self.prefs.selectedStationIndex != nil {
////
////                if self.stations.index(of: self.selectedStation!) == nil { //Selected not in the new list
////                    self.resetCurrentStation()
////                    if kDebugLog { print("Previous station lost. None selected") }
////                } else {
////                    self.popoverController!.selectedStation = self.selectedStation!
////                    //Saving the new index of the selected station into prefs.
////                    let newIndex = self.stations.index(of: self.selectedStation!)
////                    self.prefs.selectedStationIndex = newIndex
////                    if kDebugLog { print("Station selected in Popup") }
////                }
////
////            }
//        }
//    }
//    
//    // Reset all properties to default
//    func resetCurrentStation() {
//        //deselect popUp
//      //  self.popoverController!.stationPopup.select(nil)
//        stationManager.resetRadioPlayer()
//    }
//    
//}
//
//
////*****************************************************************
//// MARK: - Menu Remote delegation
////*****************************************************************
//
//extension MenuRadioController: MenuRemoteDelegate {
//    func menuWasClicked() {
//        switch stationManager.player.state {
//        case .error, .urlNotSet:
//            togglePopover(self)
//        default:
//            stationManager.player.togglePlaying()
//        }
//    }
//    
//    func menuWasHold() {
//        if popover.isShown { return }
//        showPopover(sender: nil)
//    }
//}
//
