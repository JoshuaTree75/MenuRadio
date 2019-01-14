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

class PreferenceManager {
    
  
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
    var selectedStationIndex: RadioStation? {
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
                let array = newValue.map { [nameKey: $0.name , streamURLKey: $0.streamURL, imageURLKey: $0.imageURL, descKey: $0.desc, groupKey: $0.group] }
                userDefaults.set(array, forKey: stationsKey)
            }
        }
        get {
            if let data = userDefaults.array(forKey: stationsKey) as! [[String: String]]? {
                let stationsArray = data.map { RadioStation(name: $0[nameKey] ?? "", streamURL: $0[streamURLKey] ?? "", imageURL: $0[imageURLKey] ?? "", desc: $0[descKey] ?? "", group: $0[groupKey] ?? "")}
                return stationsArray
            } else {
                return []
            }
        }
    }
    
    var stationsByGroups: [String : [RadioStation]] {
        let list = stations.sorted { $0.group < $1.group }
            .reduce(into: [String : [RadioStation]]()) { (newDict, station) in
                if newDict.keys.contains(station.group) {
                    newDict[station.group]!.append(station)
                } else {
                    newDict[station.group] = [station].sorted(by: { $0.name < $1.name })
                }
        }
        return list
    }
    
    var stationsByAlphabetical: [String : [RadioStation]] {
        let list = stations.reduce(into: [String : [RadioStation]]()) { (newDict, station) in
                let group = String(station.name.uppercased().first!)
                if newDict.keys.contains(group) {
                    newDict[group]!.append(station)
                } else {
                    newDict[group] = [station]
                }
            }
        return list.mapValues { $0.sorted { $0.name.localizedCompare($1.name) == .orderedAscending  }}
    }

    //*****************************************************************
    // Load default radio stations
//*****************************************************************
    
    
    func defaultStationsFromFile() -> [[String: String]] {
        
        if let path = Bundle.main.path(forResource: "DefaultRadioStations", ofType: "plist") {
            if let dataArray = NSArray(contentsOfFile: path) as! [[String: String]]? {
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
