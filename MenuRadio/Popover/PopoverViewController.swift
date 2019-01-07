//
//  PopoverViewController.swift
//  MenuRadio
//
//  Created by Ken FUKUHARA on 25/12/2018.
//  Copyright © 2018 Ken FUKUHARA. All rights reserved.
//

import Cocoa


protocol PopoverViewControllerDelegate {
    func selectedStationDidChange()
    func didPickPreference(menuItem: NSMenuItem)
    func numberOfStations() -> Int
}

class PopoverViewController: NSViewController {
    
    //*****************************************************************
    // MARK: - Attached popover
    //*****************************************************************
    
    // MARK: - IB Outlets
    
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
            if kDebugLog { print("String: \(string)") }
            scrollingStationInfo.setup(string: string)
        }
    }
    
    func updateTrackArtwork(_ track: Track?) {
        stationArtwork.image = track?.artworkImage
    }
    
    //*****************************************************************
    // MARK: - Preferences Menu
    //*****************************************************************
    
    @IBOutlet weak var prefsPopup: NSPopUpButton!
    
    @IBAction func pickPrefsMenu(_ sender: NSPopUpButton) {
        if let item = sender.selectedItem {
            switch item.title {
            case menuAbout:
                print("A propos")
                let alert = NSAlert()
                alert.messageText = "MenuRadio 0.3.1"
                alert.informativeText = "KFU ©2019"
                alert.runModal()
            case menuQuit:
                print("Quit")
            default:
                delegate?.didPickPreference(menuItem: item)
            }
        }
        
    }
    
    
    
    //*****************************************************************
    // MARK: - StackView management
    //*****************************************************************
    
    @IBOutlet weak var stackView: NSStackView!
    @IBOutlet weak var stackPlayer: NSStackView!
    // @IBOutlet weak var stackSearch: NSStackView!
    @IBOutlet weak var stackRadioList: NSScrollView!
    //@IBOutlet weak var stackCopyright: NSStackView!
    
    
    var isExpanded :Bool = false {
        willSet {
            //            NSAnimationContext.beginGrouping()
            //            NSAnimationContext.current.duration = 5.0
            //            NSAnimationContext.current.allowsImplicitAnimation = true
            //            if newValue {
            //                stackPlayer.isHidden = true
            //                //stackSearch.isHidden = false
            //                stackRadioList.isHidden = false
            //                //stackCopyright.isHidden = false
            //                print("Popover expanded")
            //            } else {
            //                stackPlayer.isHidden = false
            //                // stackSearch.isHidden = true
            //                stackRadioList.isHidden = true
            //                // stackCopyright.isHidden = true
            //                print("Popover contracted")
            //            }
            //            NSAnimationContext.endGrouping()
            
            
            //WWDC
            //            NSAnimationContext.runAnimationGroup({_ in
            //                //Indicate the duration of the animation
            //                NSAnimationContext.current.duration = 2.0
            //                //What is being animated? In this example I’m making a view transparent
            //                stackView.animator().addView(radioListView, in: NSStackView.Gravity.bottom)
            //            }, completionHandler: {
            //                //In here we add the code that should be triggered after the animation completes.
            //                print("Animation completed")
            //            })
            
            
            //            NSAnimationContext.runAnimationGroup({_ in
            //                //Indicate the duration of the animation
            //                NSAnimationContext.current().duration = 5.0
            //                //What is being animated? In this example I’m making a view transparent
            //                stackView.animator().addSubview(radioListView)
            //            }, completionHandler {
            //                //In here we add the code that should be triggered after the animation completes.
            //                print("Animation completed")
            //            })
            
            
            //            stackView.addView(radioListView, in: NSStackView.Gravity.bottom)
        }
        
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

