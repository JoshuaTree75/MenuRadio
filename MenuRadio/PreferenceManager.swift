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

private let  nameKey = "name"
private let  streamURLKey = "streamURL"
private let  imageURLKey = "imageURL"
private let  descKey = "desc"

class PreferenceManager {
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        registerDefaults()
    }
    
    func registerDefaults() {
        
        let stations = defaultStationsFromFile()
        
//        let station = 0
        
        //let encodedStation = try? PropertyListEncoder().encode(station)
        //let encodedStations = try? PropertyListEncoder().encode(stations)
        
        let defaults: [String : Any] = [autoplayKey: true,
                                        launchAtStartupKey: true,
                                        notificationsKey: false,
                                        animatedIconKey: false,
                                        selectedStationKey: 0,
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
    var selectedStation: Int? {
        set { userDefaults.set(newValue, forKey: selectedStationKey) }
        get { return userDefaults.integer(forKey: selectedStationKey) }
    }
    var stations: [RadioStation] {
        set {
            if !newValue.isEmpty {
                var stationsArray = [[String: String]]()
                for station in newValue {
                    let stationDictionary = [nameKey: station.name,
                                             streamURLKey: station.streamURL,
                                             imageURLKey: station.imageURL,
                                             descKey: station.desc]
                    stationsArray.append(stationDictionary)
                }
                userDefaults.set(stationsArray, forKey: stationsKey)
//                do { try userDefaults.set(PropertyListEncoder().encode(newValue), forKey: stationsKey)}
//                catch { if kDebugLog { print("Unable to write the station list")} }
            }
        }
        get {
            var stations = [RadioStation]()
            if let arrayOfDictionaries = userDefaults.array(forKey: stationsKey) as! [[String: String]]? {
            for dict in arrayOfDictionaries {
                let station = RadioStation(name: dict[nameKey] ?? "", streamURL: dict[streamURLKey] ?? "", imageURL: dict[imageURLKey]!, desc: dict[descKey]!)
                
                stations.append(station)
                }
            }
            return stations
//            do {
//                let encodedStation = userDefaults.object(forKey: stationsKey) as! Data
//                let stations = try PropertyListDecoder().decode([RadioStation].self, from: encodedStation)
//                return stations
//            }
//            catch { if kDebugLog { print("Unable to get the station list")} }
//            return []
        }
    }
    
    //*****************************************************************
    // Load default radio stations
    //*****************************************************************
    
    
    func defaultStationsFromFile() -> [[String: String]] {
        
        var stations: [[String: String]] = []
        
        if let path = Bundle.main.path(forResource: "DefaultRadioStations", ofType: "plist") {
            if let data = NSArray(contentsOfFile: path) {
                for stationData in data as! [Dictionary<String, String>] {
                    if let name = stationData["name"],
                        let streamURL = stationData["streamURL"],
                        let imageURL = stationData["imageURL"],
                        let desc = stationData["desc"]
                    {
                        let newStation = [nameKey: name, streamURLKey: streamURL, imageURLKey: imageURL, descKey: desc]
                        stations.append(newStation)
                    }
                }
            }
        }
        return stations
    }
    
}
