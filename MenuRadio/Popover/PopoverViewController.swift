//
//  PopoverViewController.swift
//  MenuRadio
//
//  Created by Ken FUKUHARA on 25/12/2018.
//  Copyright © 2018 Ken FUKUHARA. All rights reserved.
//

import Cocoa

class PopoverViewController: NSViewController {
    
    //*****************************************************************
    // MARK: - IB Outlets
    //*****************************************************************
    
    @IBOutlet weak var popupLabel: NSTextField!
    
    @IBOutlet weak var stationPopup: NSPopUpButton!
    
    @IBOutlet weak var stationInfo: NSTextField!
    
    
    var selectedStation: RadioStation? {
        didSet {
            if selectedStation == nil {
                if kDebugLog { print("No station selected") }
            } else {
            showStationInPopup(selectedStation!)
            }
        }
    }
    
    
    var delegate: PopoverViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        //Load the popup list
        if kDebugLog { print("View did load") }

    }
    
    func refreshPopup(withStations stations: [RadioStation]) {
        stationPopup.removeAllItems()
        for station in stations {
            stationPopup.addItem(withTitle: station.name)
        }
        
        if selectedStation != nil {
            popupLabel.stringValue = "Station:"
            stationPopup.selectItem(withTitle: selectedStation!.name)
        } else {
            popupLabel.stringValue = "Choisissez une station:"
            stationPopup.selectItem(at: -1)
        }
        if kDebugLog { print("Popup updated") }

    }
    
    private func showStationInPopup(_ station: RadioStation) {
        stationPopup.selectItem(withTitle: station.name)
    }

    @IBAction func selectStation(_ sender: NSPopUpButton) {
        delegate?.selectedStationDidChange()
    }
    
    func updateTrack(_ track: Track?) {
        stationInfo.stringValue = (track?.artist)! + " - " + (track?.title)!
    }
    
    func updateTrackArtwork(_ track: Track?) {
        
    }

    
    //*****************************************************************
    // MARK: - Storyboard instantiation
    //*****************************************************************
    
    static func freshController() -> PopoverViewController {
        //1. Get a reference to Main.storyboard.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        //let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        
        //2. Create a Scene identifier that matches the one you set just before.
        let identifier = NSStoryboard.SceneIdentifier("PopoverViewController")
        
        //3. Instantiate PopoverViewController and return it.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? PopoverViewController else {
            fatalError("Why cant i find PopoverViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}

protocol PopoverViewControllerDelegate {
    func selectedStationDidChange()
}
