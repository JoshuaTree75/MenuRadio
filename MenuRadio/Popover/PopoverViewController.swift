//
//  PopoverViewController.swift
//  MenuRadio
//
//  Created by Ken FUKUHARA on 25/12/2018.
//  Copyright © 2018 Ken FUKUHARA. All rights reserved.
//

import Cocoa

 let sectionWidth = 300.0
 let sectionHeight = 20.0
 let itemSide = 52.0
 let interitemSpacing = 7.0

//itemSide 54*4 = 216
//interItem 7*5 = 35

//total: 244

protocol PopoverViewControllerDelegate {
    func selectedStationDidChange()
    func didPickPreference(menuItem: NSMenuItem)
    func getStationsForCollectionView() -> [RadioStation]
//    func stationsDidChange()

}


class PopoverViewController: NSViewController {
    
    //*****************************************************************
    // MARK: - Initialisation
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchField()
        scrollingStationInfo.font = NSFont.systemFont(ofSize: NSFont.smallSystemFontSize)
        scrollingStationInfo.textColor = NSColor.secondaryLabelColor
        configureCollectionView()
        sortingSegmentedButton.selectedSegment = PreferenceManager.shared.sortingPredicate.rawValue
        favoritesButton.state = PreferenceManager.shared.favoritesOnly ? .on : .off
        updateStationsDictionaries()
        if kDebugLog { print("View did load") }
        
    }
    
    //*****************************************************************
    // MARK: - Sorting methods
    //*****************************************************************

    private var orderedStations: [String: [RadioStation]] = [:]
    
    var orderedSections: [String] = []
    
    @IBOutlet weak var sortingSegmentedButton: NSSegmentedControl!

    @IBAction func sortSegmentedControl(_ sender: NSSegmentedControl) {
        if sender.indexOfSelectedItem != sortingPredicate.rawValue {
            sortingPredicate = SortingPredicate(rawValue: sender.indexOfSelectedItem) ?? .alphabetical
        }
    }
    
    var sortingPredicate: SortingPredicate = .alphabetical {
        didSet {
            PreferenceManager.shared.sortingPredicate = sortingPredicate
            updateStationsDictionaries()
        }
    }
    
    func sortStations(_ stations: [RadioStation], by predicate: SortingPredicate) -> [String : [RadioStation]] {
        //By group
        var list = [String : [RadioStation]]()
        switch predicate {
        case .groups:
            list = stations.sorted { $0.group < $1.group }
                .reduce(into: [String : [RadioStation]]()) { (newDict, station) in
                    if newDict.keys.contains(station.group) {
                        newDict[station.group]!.append(station)
                    } else {
                        newDict[station.group] = [station].sorted(by: { $0.name < $1.name })
                    }
            }
            if list.keys.contains("") { switchKey(&list, fromKey: "", toKey: "Sans groupe")}
        case .alphabetical:
            list = stations.reduce(into: [String : [RadioStation]]())
            { (newDict, station) in
                let group = String(station.name.uppercased().first!)
                if newDict.keys.contains(group) { newDict[group]!.append(station) }
                else { newDict[group] = [station] }
                }
                .mapValues { $0.sorted { $0.name.localizedCompare($1.name) == .orderedAscending  }}
        }
        //list[""] = []
        return list
    }

    //*****************************************************************
    // MARK: - Filtering favorites methods
    //*****************************************************************
   
    var filterActivated: Bool = false
    var filteredStations: [String: [RadioStation]] {
        
        let stations = orderedStations.reduce(into: [String:[RadioStation]]()) { (newDict, group) in
            let filtered = group.value.filter { ($0.favorite || $0.favorite == filterActivated) }//.count
            if filtered.count > 0 {
                newDict[group.key] = filtered
            }
        }
        return stations
        
    }

    @IBOutlet weak var favoritesButton: NSButton!
    
    @IBAction func toggleFavorites(_ sender: NSButton) {
        filterActivated = !filterActivated
        updateStationsDictionaries()
    }
    
    
    //*****************************************************************
    // MARK: - Searching methods
    //*****************************************************************

    let searchWIdthClosed: CGFloat = 28.0
    let searchWidthOpened:CGFloat = 200.0 //200.0
    
    @IBOutlet weak var toolBarStackView: NSStackView!
    @IBOutlet weak var searchField: NSSearchField!
    @IBOutlet weak var searchFieldConstraint: NSLayoutConstraint!
    
    fileprivate func setupSearchField() {
        searchField.delegate = self
        searchField.focusRingType = .none
        searchField.bezelStyle = .roundedBezel
        searchField.isBezeled = false
        searchField.drawsBackground = false
        let area = NSTrackingArea.init(rect: searchField.bounds, options: [ .mouseEnteredAndExited, .activeAlways, .inVisibleRect ], owner: self, userInfo: nil)
        searchField.addTrackingArea(area)
        expand(false)
        searchFieldConstraint.constant = searchWIdthClosed
    }
    //*****************************************************************
    // MARK: - Helper methods
    //*****************************************************************

    func switchKey<T, U>(_ myDict: inout [T:U], fromKey: T, toKey: T) {
        if let entry = myDict.removeValue(forKey: fromKey) {
            myDict[toKey] = entry }
    }
    
    private func refreshSelectedStation() {
        guard let previousSelectedStation = selectedStation else { return }
        for (key, stations) in orderedStations {
            if orderedStations[key]!.contains(previousSelectedStation) {
                if let section = self.orderedSections.firstIndex(where: { $0 == key }),
                    let item = stations.firstIndex(where: { $0 == previousSelectedStation })
                {
                    self.radioListCollection.selectionIndexPaths = []
                    self.radioListCollection.selectItems(at: [IndexPath(item: item, section: section)], scrollPosition: .top)
                     break
                }
            }
        }
    }
    
    private func updateStationsDictionaries() {
        print("State: \(favoritesButton.state)")
        let stations = delegate?.getStationsForCollectionView() ?? []
        orderedStations = sortStations(stations, by: sortingPredicate)
        orderedSections = Array(filteredStations.keys).sorted { $0.localizedCompare($1) == .orderedAscending }
        if kDebugLog { print("Stations did update:\n Sections: \(orderedSections.count)\n Stations: \(orderedStations.description)") }
        radioListCollection.reloadData()
        refreshSelectedStation()
        }

    
//    func updateStationsToPrefs() {
//        delegate?.stationsDidChange()
//    }
   
    @IBOutlet weak var scrollingStationInfo: MarqueeView!
    
    @IBOutlet weak var radioListCollection: NSCollectionView!
   
    @IBOutlet weak var stationArtwork: NSImageView!
    
    var selectedStation: RadioStation? {
        didSet {
            if selectedStation != nil {
               // showStationInPopup(selectedStation!)
                PreferenceManager.shared.selectedStation = selectedStation
                delegate?.selectedStationDidChange()

            }
        }
    }
    
    
    var delegate: PopoverViewControllerDelegate?
    
    @IBOutlet weak var infoMetadataConstraint: NSLayoutConstraint!
    
    func toggleInfoMetadataConstraint() {
        
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

