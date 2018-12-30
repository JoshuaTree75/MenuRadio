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
    
    @IBOutlet weak var stationPopup: NSPopUpButton!
    
    @IBOutlet weak var scrollingStationInfo: ScrollingTextView!
    
    @IBOutlet weak var stationArtwork: NSImageView!
    
    var selectedStation: RadioStation? {
        didSet {
            if selectedStation != nil {
                showStationInPopup(selectedStation!)
          }
        }
    }
    
    
    var delegate: PopoverViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollingStationInfo.font = NSFont.systemFont(ofSize: NSFont.smallSystemFontSize)
        scrollingStationInfo.textColor = NSColor.secondaryLabelColor

        if kDebugLog { print("View did load") }

    }
    
    func refreshPopup(withStations stations: [RadioStation]) {
        stationPopup.removeAllItems()
       for station in stations {
            stationPopup.addItem(withTitle: station.name)
       }
        if selectedStation == nil {
            scrollingStationInfo.setup(string: "Choisissez une station:")
            stationPopup.selectItem(at: -1)
            stationArtwork.image = NSImage(named: AppIcon)
            if kDebugLog { print("No station selected") }
        } else {
            showStationInPopup(selectedStation!)
        }
        if kDebugLog { print("Popup updated") }
    }
    
    private func showStationInPopup(_ station: RadioStation) {
        stationPopup.selectItem(withTitle: station.name)
        scrollingStationInfo.setup(string: "")
    }

    @IBAction func selectStation(_ sender: NSPopUpButton) {
        delegate?.selectedStationDidChange()
    }
    
    func updateTrack(_ track: Track?) {
        if track != nil {
            let string = (track!.artist) + " - " + (track!.title)
            if kDebugLog { print("String: \(string)")
                scrollingStationInfo.setup(string: string)
            }
        }
    }
    
    func updateTrackArtwork(_ track: Track?) {
        stationArtwork.image = track?.artworkImage
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
