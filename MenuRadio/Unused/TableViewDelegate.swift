//
//  TableViewDelegate.swift
//  MenuRadio
//
//  Created by Ken FUKUHARA on 05/01/2019.
//  Copyright © 2019 Ken FUKUHARA. All rights reserved.
//

import AppKit


extension PopoverViewController: NSTableViewDelegate, NSTableViewDataSource {
    
    var stationsWithHeaders: [String: [RadioStation]] {
        get {
            let stations = delegate?.getStationsForCollectionView() ?? [:]
            //            if stations.count > 0 {
            //                var groups: [String] = []
            //                for station in stations {
            //                    if !groups.contains(station.group) {
            //                        groups.append(station.group)
            //                    }
            //                }
            //if $1.group == $0.group {add
            return stations
        }
        
    }
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 1 //stationsWithHeaders.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        //        var text = ""
        //        var cellIdentifier = ""
        //
        //        let item = stationsWithHeaders[row]
        //
        //        if tableColumn == tableView.tableColumns[0] {
        //            text = item.name
        //            cellIdentifier = CellIdentifiers.NameCell
        //        } else if tableColumn == tableView.tableColumns[1] {
        //            text = item.streamURL
        //            cellIdentifier = CellIdentifiers.StreamURLCell
        //        }
        //
        //        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
        //            cell.textField?.stringValue = text
        //            return cell
        //        }
        return nil
    }
    
    enum CellIdentifiers {
        static let NameCell = "NameCellID"
        static let StreamURLCell = "StreamURLCellID"
        static let HeaderCell = "HeaderCellID"
    }
    
    func tableView(_ tableView: NSTableView, isGroupRow row: Int) -> Bool {
        if row == 3 { return true }
        return false
    }
}
