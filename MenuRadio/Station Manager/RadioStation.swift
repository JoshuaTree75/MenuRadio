//
//  RadioStation.swift
//  Swift Radio
//
//  Created by Matthew Fecher on 7/4/15.
//  Copyright (c) 2015 MatthewFecher.com. All rights reserved.
//

import Foundation

//*****************************************************************
// Radio Station
//*****************************************************************

class RadioStation: Codable {
    
    var name: String
    var streamURL: String
    var imageURL: String
    var desc: String
    var group: String
    var favorite: Bool
//    var country: String
//    var website: String
//    var categories: [String]

    init(name: String, streamURL: String, imageURL: String = "", desc: String = "", group: String = "Without group", favorite: Bool = false) {
        self.name = name
        self.streamURL = streamURL
        self.imageURL = imageURL
        self.desc = desc
        self.group = group
        self.favorite = favorite
    }
    
    var description: String {
        return "Name: \(name) (groupe: \(group))"
    }
}

extension RadioStation: Equatable {
    
    static func ==(lhs: RadioStation, rhs: RadioStation) -> Bool {
        return (lhs.name == rhs.name) && (lhs.streamURL == rhs.streamURL) && (lhs.imageURL == rhs.imageURL) && (lhs.desc == rhs.desc) && (lhs.group == rhs.group)
    }
    

}
