//
//  TableViewDelegate.swift
//  MenuRadio
//
//  Created by Ken FUKUHARA on 05/01/2019.
//  Copyright © 2019 Ken FUKUHARA. All rights reserved.
//

import AppKit

extension PopoverViewController: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return delegate?.numberOfStations() ?? 0
    }
    
    
    
}
