//
//  PreferenceManager.swift
//  MenuRadio
//
//  Created by Ken FUKUHARA on 25/12/2018.
//  Copyright © 2018 Ken FUKUHARA. All rights reserved.
//

import Foundation

private let autoplayKey = "autoPlay"
private let launchAtStartupKey = "launchAtStartup"
private let notificationsKey = "notifications"
private let animatedIconKey = "animatedIcon"
private let selectedStationKey = "selectedStation"
private let stationsKey = "stations"

class PreferenceManager {
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        registerDefaults()
    }
    
    func registerDefaults() {
        
        let stations: [[String: String]] =  [["name": "Absolute Country Hits",
                                          "streamURL": "http://strm112.1.fm/acountry_mobile_mp3",
                                          "imageURL": "station-absolutecountry.png",
                                          "desc": "The Music Starts Here",
                                          "longDesc": "All your favorite country hits and artists, from Johnny Cash to Taylor Swift, on 1.FM's Absolute Country, playing non-stop crooners and banjos, dance-tunes and fiddles, ballads and harmonicas. Absolute Country focuses on 5th, 6th and 7th generation Country (from the 90s on) but often delves into classic, older tunes as well."],
                                         ["name": "Newport Folk Radio",
                                          "streamURL": "http://rfcmedia.streamguys1.com/Newport.mp3",
                                          "imageURL": "station-newportfolk.png",
                                          "desc": "Are you ready to Folk?",
                                          "longDesc": "Do you like Indie music and along with that wants a radio that will provide lots of folk music in their daily radio programs than wait not just tune in to Newport Folk Radio as this is the kind of radio that has got lots of types of Indie music in their daily radio programs along with popular Folk music."],
                                         ["name": "FranceMusique",
                                          "streamURL": "https://direct.francemusique.fr/live/francemusique-midfi.mp3?",
                                          "imageURL": "station-newportfolk.png",
                                          "desc": "Are you ready to Folk?",
                                          "longDesc": "Do you like Indie music and along with that wants a radio that will provide lots of folk music in their daily radio programs than wait not just tune in to Newport Folk Radio as this is the kind of radio that has got lots of types of Indie music in their daily radio programs along with popular Folk music."],
                                         ["name": "The Alt Vault",
                                          "streamURL": "http://jupiter.prostreaming.net/altmixxlow",
                                          "imageURL": "station-altvault.png",
                                          "desc": "Your Lifestyle... Your Music!",
                                          "longDesc": "The Alt Vault live broadcasting from Kissimmee, FL. The Alt Vault broadcast various kind of 90s’s pop, rock, classic, talk, culture, dance, electronic etc. The Alt Vault streaming music and programs both in online. The Alt Vault is 24 hour 7 day live Online radio."],
                                         ["name": "Classic Rock",
                                          "streamURL": "http://rfcmedia.streamguys1.com/classicrock.mp3",
                                          "imageURL": "station-classicrock",
                                          "desc": "Classic Rock Hits",
                                          "longDesc": "Classic rock is a radio format which developed from the album-oriented rock (AOR) format in the early 1980s. In the United States, the classic rock format features music ranging generally from the late 1960s to the late 1980s, primarily focusing on commercially successful hard rock popularized in the 1970s. The radio format became increasingly popular with the baby boomer demographic by the end of the 1990s."],
                                         ["name": "Radio 1190",
                                          "streamURL": "http://radio1190.colorado.edu:8000/high.mp3",
                                          "imageURL": "",
                                          "desc": "KVCU - Boulder, CO",
                                          "longDesc": "Radio 1190 is the bomb."]]

        let station = RadioStation(name: list[0]["name"]!, streamURL: list[0]["streamURL"]!, imageURL: list[0]["imageURL"]!, desc: list[0]["desc"]!, longDesc: list[0]["longDesc"]!)
        
        let defaults: [String : Any] = [autoplayKey: true,
                                        launchAtStartupKey: true,
                                        notificationsKey: false,
                                        animatedIconKey: false,
                                        selectedStationKey: station,
                                        stationsKey: stations]
        userDefaults.register(defaults: defaults)
    }
    
 
}
