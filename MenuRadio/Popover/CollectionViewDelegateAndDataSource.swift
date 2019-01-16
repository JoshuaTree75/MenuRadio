//
//  CollectionViewDelegateAndDataSource.swift
//  MenuRadio
//
//  Created by Ken FUKUHARA on 11/01/2019.
//  Copyright © 2019 Ken FUKUHARA. All rights reserved.
//

import AppKit

//MARK: Helper functions
extension PopoverViewController {
    func configureCollectionView() {
        // 1
        radioListCollection.dataSource = self
        radioListCollection.delegate = self
        
        //2
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: PopoverViewController.itemSide, height: PopoverViewController.itemSide)
        flowLayout.sectionInset = NSEdgeInsets(top: CGFloat(PopoverViewController.interitemSpacing),
                                               left: CGFloat(PopoverViewController.interitemSpacing),
                                               bottom: CGFloat(PopoverViewController.interitemSpacing),
                                               right: CGFloat(PopoverViewController.interitemSpacing))
        
        flowLayout.minimumInteritemSpacing = CGFloat(PopoverViewController.interitemSpacing)
        flowLayout.minimumLineSpacing = CGFloat(PopoverViewController.interitemSpacing)
        radioListCollection.collectionViewLayout = flowLayout
        flowLayout.sectionHeadersPinToVisibleBounds = true
        // 2
        //view.wantsLayer = true
        // 3
        //radioListCollection.layer?.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
    }
}

//MARK: NSCollectionViewDelegateFlowLayout
extension PopoverViewController: NSCollectionViewDelegateFlowLayout {
    static let sectionWidth = 300.0
    static let sectionHeight = 24.0
    static let itemSide = 52.0
    static let interitemSpacing = 7.0
    //total: 244
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSSize(width: PopoverViewController.sectionWidth, height: PopoverViewController.sectionHeight)
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
//        if selectionIndexPath == indexPath {
//            return CGSize(width: PopoverViewController.itemSide, height: PopoverViewController.itemSide*2)
//        } else {
        return CGSize(width: PopoverViewController.itemSide, height: PopoverViewController.itemSide)
//        }
        
    }
    

}
// MARK: NSCollectionViewDataSource
extension PopoverViewController: NSCollectionViewDataSource {
    
    var unorderedStations: [RadioStation] {
        return delegate?.getStationsForCollectionView() ?? []
    }
    
    var orderedStations: [String: [RadioStation]] {
        return sortStations(by: sortingPredicate)
    }
    
    var orderedSections: [String] {
        return Array(orderedStations.keys).sorted { $0.localizedCompare($1) == .orderedAscending }
    }
    
    func sortStations(by predicate: SortingPredicate) -> [String : [RadioStation]] {
        //By group
        switch predicate {
        case .groups:
            let list = unorderedStations.sorted { $0.group < $1.group }
                .reduce(into: [String : [RadioStation]]()) { (newDict, station) in
                    if newDict.keys.contains(station.group) {
                        newDict[station.group]!.append(station)
                    } else {
                        newDict[station.group] = [station].sorted(by: { $0.name < $1.name })
                    }
            }
            return list
        case .alphabetical:
            let list = unorderedStations.reduce(into: [String : [RadioStation]]()) { (newDict, station) in
                let group = String(station.name.uppercased().first!)
                if newDict.keys.contains(group) {
                    newDict[group]!.append(station)
                } else {
                    newDict[group] = [station]
                }
            }
            return list.mapValues { $0.sorted { $0.name.localizedCompare($1.name) == .orderedAscending  }}
        case .favorites:
            let list = unorderedStations.filter { $0.favorite }
                .sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
            var dict: [String: [RadioStation]] = [:]
            dict["Favoris"] = list
            return dict
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
            return orderedStations[orderedSections[section]]!.count
//            let group = Array(stations.keys)[section]
//            return stations[group]!.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionItem"), for: indexPath) as! CollectionItem
        let stationsInGroup = orderedStations[orderedSections[indexPath.section]]
        item.radioStation = stationsInGroup![indexPath.item]
        return item
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
            return orderedSections.count

    }
    
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {

        let view = collectionView.makeSupplementaryView(ofKind: NSCollectionView.elementKindSectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeaderView"), for: indexPath) as! HeaderView
        // 2
            view.groupLabel.stringValue = orderedSections[indexPath.section]
//            let numberOfItemsInSection = imageDirectoryLoader.numberOfItemsInSection(indexPath.section)
//            view.imageCount.stringValue = "\(numberOfItemsInSection) image files"
        return view
    }
}

// MARK: NSCollectionViewDelegate
extension PopoverViewController: NSCollectionViewDelegate {

    func highlightItems(selected: Bool, at indexPath: IndexPath) {
        guard let item = radioListCollection.item(at: indexPath) else { return }
        (item as! CollectionItem).setHighlight(selected: selected)

    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        if let station = orderedStations[orderedSections[(indexPaths.first?.section)!]]?[(indexPaths.first?.item)!] {
            selectedStation = station
            highlightItems(selected: true, at: indexPaths.first!)
        }
    }

    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        highlightItems(selected: false, at: indexPaths.first!)
    }
    
}
