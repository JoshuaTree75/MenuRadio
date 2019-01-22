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
protocol CollectionItemDelegate {
    func didModifyStation()
}

class CollectionItem: NSCollectionViewItem {

    
    // 1
    var radioStation: RadioStation? {
        didSet {
            guard isViewLoaded else { return }
            print("Radiostation: \(radioStation)")
            if let radioStation = radioStation {
                self.iconView.image = NSImage(named: radioStation.imageURL) ?? #imageLiteral(resourceName: "iconUrlNotSet")
                stationName.stringValue = radioStation.name
                favoriteButton.state = radioStation.favorite ? .on : .off
                favoriteButton.isHidden = !radioStation.favorite
            } else {
                iconView.image = nil
                stationName.stringValue = ""
            }
        }
    }
    
    @IBOutlet weak var iconView: NSImageView!
    @IBOutlet weak var stationName: NSTextField!
    @IBOutlet weak var editButton: NSButton!
    @IBOutlet weak var favoriteButton: NSButton! {
        didSet {
        }
    }
    
    @IBAction func setFavorite(_ sender: NSButton) {
        if radioStation != nil {
            radioStation!.favorite = favoriteButton.state == .on ? true: false
           print(favoriteButton.state)
           print(radioStation!.favorite)
        }
    }
    @IBAction func editStation(_ sender: NSButton) {
        print("edit")
    }
    
    // 2
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
     view.layer?.masksToBounds = false
        view.layer?.shadowColor = NSColor.controlAccentColor.cgColor
        view.layer?.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer?.shadowRadius = 4.0

//
       // editButton.wantsLayer = true
//        editButton.layer?.masksToBounds = false
 //       print("editButton.layer?.contentsRect: \(editButton.layer?.contentsRect)")
//        editButton.layer?.isOpaque = false //keep for performance
       // editButton.layer?.masksToBounds = true
        //editButton.layer?.backgroundColor = CGColor.clear
    //    editButton.alphaValue = 0.75
        //editButton.contentTintColor = NSColor.controlAccentColor
       // view.layer?.borderColor = NSColor.controlAccentColor.cgColor
       // view.layer?.cornerRadius = 8.0
        //view.layer?.shadowOffset = CGSize(width: 0.0, height: -7.0)

        let area = NSTrackingArea.init(rect: iconView.bounds, options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways], owner: self, userInfo: nil)
        iconView.addTrackingArea(area)

    }
    override func mouseEntered(with event: NSEvent) {
       editButton.isHidden = false
        favoriteButton.isHidden = false
      print((favoriteButton.cell as! NSButtonCell).highlightsBy)
//        = .changeBackgroundCellMask
//        view.setNeedsDisplay(favoriteButton.frame)
//
    }
    
    override func mouseExited(with event: NSEvent) {
        editButton.isHidden = true
        if radioStation != nil {
            if !radioStation!.favorite { favoriteButton.isHidden = true }
            else { favoriteButton.isHidden = false }
        }
    }
 
    func setHighlight(selected: Bool) {
        view.layer?.borderColor = NSColor.controlAccentColor.cgColor
       view.layer?.borderWidth = selected ? 3.0 : 0.0
      // view.layer?.backgroundColor = selected ? NSColor.controlAccentColor.cgColor : CGColor.clear
        view.layer?.shadowOpacity = selected ? 1.0 : 0.0
    }
}
