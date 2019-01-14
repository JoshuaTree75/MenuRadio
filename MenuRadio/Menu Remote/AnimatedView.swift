//
//  AnimatedView.swift
//  MenuRadio
//
//  Created by Ken FUKUHARA on 24/12/2018.
//  Copyright © 2018 Ken FUKUHARA. All rights reserved.
//

import Foundation
import AppKit

class AnimatedView: NSImageView {
    
    var imageNamePattern = "" {
        didSet {
            if imageNamePattern != oldValue {
                self.image = NSImage(named: imageNamePattern)
            }
        }
    }
    
    private var currentFrame = 1
    private var animTimer = Timer.init()
    
    private var imageCount: Int {
        var index = 1
        while NSImage(named: NSImage.Name("\(imageNamePattern) \(index)")) != nil {
            index += 1
        }
        return index - 1
    }
    
    func startAnimating() {
        if imageCount > 1 {
            stopAnimating()
            currentFrame = 1
            animTimer = Timer.scheduledTimer(timeInterval: 4.0 / 30.0, target: self, selector: #selector(self.updateImage(_:)), userInfo: nil, repeats: true)
        } else {
            stopAnimating()
        }
    }
    
    func stopAnimating() {
        animTimer.invalidate()
        self.image = NSImage(named: imageNamePattern)
    }
    
    @objc private func updateImage(_ timer: Timer?) {
        setImage(frameCount: currentFrame)
        
        if currentFrame < imageCount {
            currentFrame += 1
        } else {
            currentFrame = 1
        }
        
    }
    
    private func setImage(frameCount: Int) {
        let imagePath = "\(imageNamePattern) \(frameCount)"
        guard let image =  NSImage(named: NSImage.Name(imagePath)) else {return }
        
        
        image.isTemplate = true // best for dark mode
        self.imageScaling = .scaleProportionallyUpOrDown
        
        DispatchQueue.main.async {
            self.image = image
            print("Switching image to: \(imagePath)")
        }
    }
    
}
