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
    
    @IBOutlet weak var stationInfo: NSTextField!
    
    var delegate: PopoverViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        //Load the popup list
        
    }
    
    func loadPopup(withStations stations: [RadioStation]) {
        stationPopup.removeAllItems()
        for station in stations {
            stationPopup.addItem(withTitle: station.name)
        }
        if kDebugLog { print("Popup updated") }

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
