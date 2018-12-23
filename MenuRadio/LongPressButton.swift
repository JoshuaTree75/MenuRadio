//
//  LongPressButton.swift
//  RadioGaga
//
//  Created by Ken FUKUHARA on 23/12/2018.
//  Copyright © 2018 Ken FUKUHARA. All rights reserved.
//

import Foundation
import AppKit

// TODO: Should improve the code with protocol implementation but can't without using non computed variables (for the timer).

//protocol LongPressButton {
//    var longPressActivated: Bool {get set}
//    func longPress()
//}
//
//extension NSButton: LongPressButton {
//
//    var longPressActivated: Bool {
//        get {
//            return true
//        }
//        set {
//        }
//    }
//
//    private var mouseTimer: Timer? {
//            return Timer ()
//    }
//
//    open override func mouseDown(with event: NSEvent) {
//        if longPressActivated {
//        //Setup a timer
//        mouseTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1.5), target: self, selector: #selector(longPress), userInfo: event, repeats: false)
//        } else {
//            self.mouseDown(with: event)
//        }
//    }
//
//    //In mouseUp:, destroy the timer:
//    override open func mouseUp(with event: NSEvent) {
//        if longPressActivated {
//            if mouseTimer != nil {
//                mouseTimer!.invalidate()
//                mouseTimer = nil
//                printView("Short mouse click")
//            }
//        } else {
//            self.mouseUp(with: event)
//        }
//    }
//
//    //If the timer fires, then you know that the mouse button has been held down for your specified period of time, and you can take whatever action you like:
//    @objc func longPress() {
//        mouseTimer = nil
//        print("Mouse held")
//        //Show popover
//    }
//}

class LongPressButton: NSImageView {

    var delegate: LongPressButtonDelegate?
    
    private var mouseTimer: Timer? = Timer()
    private let mouseHeldDelay: TimeInterval = 0.47
    
    open override func mouseDown(with event: NSEvent) {
        //Setup a timer
        mouseTimer = Timer.scheduledTimer(timeInterval: mouseHeldDelay, target: self, selector: #selector(mouseWasHeld), userInfo: event, repeats: false)
    }

    //In mouseUp:, destroy the timer:
    override func mouseUp(with event: NSEvent) {
        if mouseTimer != nil {
            mouseTimer!.invalidate()
            mouseTimer = nil
            delegate?.click()
        }
    }

    //If the timer fires, then you know that the mouse button has been held down for your specified period of time, and you can take whatever action you like:
    @objc func mouseWasHeld() {
        mouseTimer = nil
        delegate?.longPress()
    }
}

protocol LongPressButtonDelegate {
    func longPress()
    func click()
}
