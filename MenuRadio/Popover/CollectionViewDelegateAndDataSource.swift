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
        return CGSize(width: PopoverViewController.itemSide, height: PopoverViewController.itemSide)
    }
    

}
// MARK: NSCollectionViewDataSource
extension PopoverViewController: NSCollectionViewDataSource {
    var stations: [String: [RadioStation]]? { return delegate?.getStationsForCollectionView()}
    
    var sections: [String] {
        return Array(stations!.keys).sorted { $0.localizedCompare($1) == .orderedAscending }
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        if let stations = stations {
            return stations[sections[section]]!.count
//            let group = Array(stations.keys)[section]
//            return stations[group]!.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionItem"), for: indexPath) as! CollectionItem
        if let stations = stations {
            let stationsInGroup = stations[sections[indexPath.section]]
            item.radioStation = stationsInGroup![indexPath.item]
        }
        return item
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        if stations != nil {
            return sections.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        
        let view = collectionView.makeSupplementaryView(ofKind: NSCollectionView.elementKindSectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeaderView"), for: indexPath) as! HeaderView
        // 2

        if stations != nil {
            view.groupLabel.stringValue = sections[indexPath.section]
//            let numberOfItemsInSection = imageDirectoryLoader.numberOfItemsInSection(indexPath.section)
//            view.imageCount.stringValue = "\(numberOfItemsInSection) image files"
        }
        return view
    }
}

// MARK: NSCollectionViewDelegate
extension PopoverViewController: NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        if let station = stations?[sections[(indexPaths.first?.section)!]]?[(indexPaths.first?.item)!] {
            selectedStation = station
        }
    }
    func collectionView(_ collectionView: NSCollectionView, shouldSelectItemsAt indexPaths: Set<IndexPath>) -> Set<IndexPath> {
        print("kjhhjkfkj")
        return indexPaths
    }
}
