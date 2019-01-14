//
//  CollectionItem.swift
//  MenuRadio
//
//  Created by Ken FUKUHARA on 11/01/2019.
//  Copyright © 2019 Ken FUKUHARA. All rights reserved.
//

import Cocoa

//class AspectFillImageView: NSImageView {
//    override var intrinsicContentSize: CGSize {
//        guard let img = self.image else { return .zero }
//        var ratio: CGFloat
//        print(img.size.height/img.size.width)
//        if img.size.height < img.size.width {
//           ratio = self.frame.size.height / img.size.height
//        } else {
//           ratio = self.frame.size.width / img.size.width
//        }
//        print(ratio)
//        return CGSize(width: img.size.width * ratio, height: img.size.height * ratio)
//    }
//}

class CollectionItem: NSCollectionViewItem {

    // 1
    var radioStation: RadioStation? {
        didSet {
            guard isViewLoaded else { return }
            if let radioStation = radioStation {
                self.iconView.image = NSImage(named: radioStation.imageURL) ?? #imageLiteral(resourceName: "iconUrlNotSet")
                stationName.stringValue = radioStation.name
            } else {
                iconView.image = nil
                stationName.stringValue = ""
            }
        }
    }
    
    @IBOutlet weak var iconView: NSImageView!
    @IBOutlet weak var stationName: NSTextField!
    @IBOutlet weak var editButton: NSButton!
    @IBAction func editStation(_ sender: NSButton) {
    }
    
    // 2
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        
        let area = NSTrackingArea.init(rect: iconView.bounds, options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways], owner: self, userInfo: nil)
        iconView.addTrackingArea(area)
    }
    override func mouseEntered(with event: NSEvent) {
       editButton.isHidden = false
    }
    
    override func mouseExited(with event: NSEvent) {
        editButton.isHidden = true
    }
}
