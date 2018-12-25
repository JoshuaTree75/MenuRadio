//
//  PreferenceManager.swift
//  MenuRadio
//
//  Created by Ken FUKUHARA on 25/12/2018.
//  Copyright © 2018 Ken FUKUHARA. All rights reserved.
//

import Foundation

private let autoplay = "autoPlay"
private let launchAtStartup = "launchAtStartup"
private let notifications = "notifications"
private let animatedIcon = "animatedIcon"
private let defaultUrl = "defaultUrl"

class PreferenceManager {
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        registerDefaults()
    }
    
    func registerDefaults() {
        let defaults: [String : Any] = [autoplay: true,
                                        launchAtStartup: true,
                                        notifications: false,
                                        animatedIcon: false,
                                        defaultUrl: "https://ycradio.stream.publicradio.org/ycradio.mp3"]
        userDefaults.register(defaults: defaults)
    }
}
