//
//  PopoverDelegate.swift
//  MenuRadio
//
//  Created by Ken FUKUHARA on 09/01/2019.
//  Copyright © 2019 Ken FUKUHARA. All rights reserved.
//

import Foundation
import AppKit
//extension MenuRadioController: NSWindowDelegate {
//    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
//        popoverController?.radioListCollection.collectionViewLayout?.
//        return frameSize
//    }
//}
extension MenuRadioController: NSPopoverDelegate {
    
    //*****************************************************************
    // MARK: - Popover delegation
    //*****************************************************************
    
    func popoverShouldDetach(_ popover: NSPopover) -> Bool {
        return false
    }
    
    func popoverDidShow(_ notification: Notification) {
        if kDebugLog { print("popover did show") }
        
    }
    
    func popoverDidClose(_ notification: Notification) {
        let closeReason = notification.userInfo![NSPopover.closeReasonUserInfoKey] as! String
        if (closeReason == NSPopover.CloseReason.standard.rawValue) {
            if kDebugLog { print("closeReason: popover did close") }
//            if let vc = popover.contentViewController as? PopoverViewController {
//                vc.isExpanded = false
//                if kDebugLog { print("vc.stackView: \(vc.stackView.subviews.description)") }
//            }
        }
        //Never called, don't know why -> popoverDidDetatch(:) used instead
        if (closeReason == NSPopover.CloseReason.detachToWindow.rawValue) {
            if kDebugLog { print("closeReason: popover did detach") }
        }
    }
    
    
    //*****************************************************************
    // MARK: - Popover management
    //*****************************************************************
    
    
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
            if kDebugLog { print("closePopover") }
        } else {
            showPopover(sender: sender)
            if kDebugLog { print("showPopover") }
        }
    }
    
    func showPopover(sender: Any?) {
        if let icon = menuRemote.menuView {
            popover.show(relativeTo: icon.bounds, of: icon, preferredEdge: NSRectEdge.minY)
//            if (popoverTransiencyMonitor == nil)
//            {
//                popoverTransiencyMonitor = NSEvent.addGlobalMonitorForEvents(matching: [NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.rightMouseDown], handler: {event in
//                    self.closePopover(sender: sender)
//                }) as? NSEvent
//            }
        }
    }
    
    func closePopover(sender: Any?) {
        if popoverTransiencyMonitor != nil {
            NSEvent.removeMonitor(popoverTransiencyMonitor!)
            popoverTransiencyMonitor = nil;
        }
        popover.performClose(sender)
        
    }
    
}
