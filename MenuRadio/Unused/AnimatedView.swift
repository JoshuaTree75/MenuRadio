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
    private var currentFrame = 1
    private var animTimer : Timer
    private var statusBarItem: NSStatusItem!
    private var imageNamePattern: String!
    private var imageCount : Int!
    
    let length = NSStatusItem.squareLength
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(imageNamePattern: String, imageCount: Int, frame: NSRect) {
        
        self.animTimer = Timer.init()
        self.imageNamePattern = imageNamePattern
        self.imageCount = imageCount
        super.init(frame: frame)
        
    }
    
    func changePattern(forImagePattern pattern: String, imageCount count: Int) {
        imageNamePattern = pattern
        imageCount = count
    }
    
    func startAnimating() {
        if imageCount > 1 {
            stopAnimating()
            currentFrame = 1
            animTimer = Timer.scheduledTimer(timeInterval: 2.0 / 30.0, target: self, selector: #selector(self.updateImage(_:)), userInfo: nil, repeats: true)
        } else {
            stopAnimating()
        }
    }
    
    func stopAnimating() {
        animTimer.invalidate()
        setImage(frameCount: 1)
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
        let imagePath = "\(imageNamePattern!) \(frameCount)"
        print("Switching image to: \(imagePath)")
        let image = NSImage(named: NSImage.Name(imagePath))
        image?.isTemplate = true // best for dark mode
        self.imageScaling = .scaleProportionallyUpOrDown
        
        DispatchQueue.main.async {
            self.image = image
        }
    }
    
}
