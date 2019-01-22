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
        flowLayout.itemSize = NSSize(width: itemSide, height: itemSide)
        flowLayout.sectionInset = NSEdgeInsets(top: CGFloat(interitemSpacing),
                                               left: CGFloat(interitemSpacing),
                                               bottom: CGFloat(interitemSpacing),
                                               right: CGFloat(interitemSpacing))
        
        flowLayout.minimumInteritemSpacing = CGFloat(interitemSpacing)
        flowLayout.minimumLineSpacing = CGFloat(interitemSpacing)
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

    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSSize(width: sectionWidth, height: sectionHeight)
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
//        if selectionIndexPath == indexPath {
//            return CGSize(width: PopoverViewController.itemSide, height: PopoverViewController.itemSide*2)
//        } else {
        return CGSize(width: itemSide, height: itemSide)
//        }
        
    }
    

}
// MARK: NSCollectionViewDataSource
extension PopoverViewController: NSCollectionViewDataSource {

    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
            return filteredStations[orderedSections[section]]!.count
//            let group = Array(stations.keys)[section]
//            return stations[group]!.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionItem"), for: indexPath) as! CollectionItem
        let stationsInGroup = filteredStations[orderedSections[indexPath.section]]
        item.radioStation = stationsInGroup![indexPath.item]
        let isItemSelected = collectionView.selectionIndexPaths.contains(indexPath as IndexPath)
        item.setHighlight(selected: isItemSelected)
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
        if let station = filteredStations[orderedSections[(indexPaths.first!.section)]]?[(indexPaths.first!.item)] {
            print("SelectedStation: \(selectedStation?.description))")
            print("Cliqued Station: \(String(describing: station.description)) [\(String(describing: indexPaths.first!.section)),\(String(describing: indexPaths.first!.item))]")
            selectedStation = station
            highlightItems(selected: true, at: indexPaths.first!)
        }
    }

    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        highlightItems(selected: false, at: indexPaths.first!)
    }
    
}
