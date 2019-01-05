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
        
        let stations = defaultStationsFromFile()
        
        let station = stations[0]
        
        let encodedStation = try? PropertyListEncoder().encode(station)
        let encodedStations = try? PropertyListEncoder().encode(stations)
        
        let defaults: [String : Any] = [autoplayKey: true,
                                        launchAtStartupKey: true,
                                        notificationsKey: false,
                                        animatedIconKey: false,
                                        selectedStationKey: encodedStation ?? "",
                                        stationsKey: encodedStations ?? ""]
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
        set {
            if newValue != nil {
                do { try userDefaults.set(PropertyListEncoder().encode(newValue), forKey: selectedStationKey) }
                catch { if kDebugLog { print("Unable to write the new selected station")} }
            }
        }
        get {
            do {
                let encodedStation = userDefaults.object(forKey: selectedStationKey) as! Data
                let station = try PropertyListDecoder().decode(RadioStation.self, from: encodedStation)
                return station
            }
            catch { if kDebugLog { print("Unable to get the selected station")} }
            return nil
        }
    }
    var stations: [RadioStation] {
        set {
            if !newValue.isEmpty {
                do { try userDefaults.set(PropertyListEncoder().encode(newValue), forKey: stationsKey)}
                catch { if kDebugLog { print("Unable to write the station list")} }
            }
        }
        get {
            do {
                //typealias RadioStationArray = [RadioStation]
                let encodedStation = userDefaults.object(forKey: stationsKey) as! Data
                let stations = try PropertyListDecoder().decode([RadioStation].self, from: encodedStation)
                return stations
            }
            catch { if kDebugLog { print("Unable to get the station list")} }
            return []
        }
    }
    
    //*****************************************************************
    // Load default radio stations
    //*****************************************************************
    
    
    func defaultStationsFromFile() -> [RadioStation] {
        
        var stations: [RadioStation] = []
        
        if let path = Bundle.main.path(forResource: "DefaultRadioStations", ofType: "plist") {
            if let data = NSArray(contentsOfFile: path) {
                for stationData in data as! [Dictionary<String, String>] {
                    if let name = stationData["name"],
                        let streamURL = stationData["streamURL"],
                        let imageURL = stationData["imageURL"],
                        let desc = stationData["desc"]
                    {
                        let newStation = RadioStation(name: name, streamURL: streamURL, imageURL: imageURL, desc: desc)
                        stations.append(newStation)
                    }
                }
            }
        }
        return stations
    }
    
}
