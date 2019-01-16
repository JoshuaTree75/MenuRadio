//
//  PreferenceManager.swift
//  MenuRadio
//
//  Created by Ken FUKUHARA on 25/12/2018.
//  Copyright © 2018 Ken FUKUHARA. All rights reserved.
//

import Foundation
import AppKit

private let autoplayKey = "autoPlay"
private let launchAtStartupKey = "launchAtStartup"
private let notificationsKey = "notifications"
private let animatedIconKey = "animatedIcon"
private let selectedStationKey = "selectedStation"
private let stationsKey = "stations"

private let  nameKey = "name"
private let  streamURLKey = "streamURL"
private let  imageURLKey = "imageURL"
private let  descKey = "desc"
private let  groupKey = "group"
private let favoriteKey = "favorite"

class PreferenceManager {
    
    /// Returns the singleton `PreferenceManager` instance.
    public static let shared = PreferenceManager()

    private let userDefaults = UserDefaults.standard
    
    init() {
        registerDefaults()
    }
    
    func registerDefaults() {
        let stations = defaultStationsFromFile()
        let defaults: [String : Any] = [autoplayKey: true,
                                        launchAtStartupKey: true,
                                        notificationsKey: false,
                                        animatedIconKey: false,
                                        selectedStationKey: "", //a streamURL
                                        stationsKey: stations]
        userDefaults.register(defaults: defaults)
    }
    
    var autoplay: Bool {
        set { userDefaults.set(newValue, forKey: autoplayKey) }
        get { return userDefaults.bool(forKey: autoplayKey) }
    }
    var launchAtStartup: Bool {
        set { userDefaults.set(newValue, forKey: launchAtStartupKey) }
        get { return userDefaults.bool(forKey: launchAtStartupKey) }
    }
    var notifications: Bool {
        set { userDefaults.set(newValue, forKey: notificationsKey) }
        get { return userDefaults.bool(forKey: notificationsKey) }
    }
    var animatedIcon: Bool {
        set { userDefaults.set(newValue, forKey: animatedIconKey) }
        get { return userDefaults.bool(forKey: animatedIconKey) }
    }
    var selectedStation: RadioStation? {
        set { if newValue != nil {
            userDefaults.set(newValue!.streamURL, forKey: selectedStationKey) }
        }
        get {
            let streamURL = userDefaults.string(forKey: selectedStationKey)
            return stations.filter({$0.streamURL == streamURL}).first
        }
    }
    var stations: [RadioStation] {
        set {
            if !newValue.isEmpty {
                let array = newValue.map { [nameKey: $0.name , streamURLKey: $0.streamURL, imageURLKey: $0.imageURL, descKey: $0.desc, groupKey: $0.group, favoriteKey: $0.favorite] }
                userDefaults.set(array, forKey: stationsKey)
            }
        }
        get {
            if let data = userDefaults.array(forKey: stationsKey) as! [[String: Any]]? {
                let stationsArray = data.map { RadioStation(name: $0[nameKey] as? String ?? "", streamURL: $0[streamURLKey] as? String ?? "", imageURL: $0[imageURLKey] as? String ?? "", desc: $0[descKey] as? String ?? "", group: $0[groupKey] as? String ?? "", favorite: $0[favoriteKey] as? Bool ?? false)}
                return stationsArray
            } else {
                return []
            }
        }
    }


    //*****************************************************************
    // Load default radio stations
//*****************************************************************
    
    
    func defaultStationsFromFile() -> [[String: Any]] {
        
        if let path = Bundle.main.path(forResource: "DefaultRadioStations", ofType: "plist") {
            if let dataArray = NSArray(contentsOfFile: path) as! [[String: Any]]? {
                return dataArray
                //stations = data.map { station -> RadioStation in
                //if let streamURL = station[streamURLKey], let name = station[nameKey] {
                //if !streamURLKey.isEmpty {
                //return RadioStation(name: name, streamURL: streamURL, imageURL: station[imageURLKey] ?? "", desc: station[descKey] ?? "") }
                //}
                //}
            }
        }
        return []
    }
}
