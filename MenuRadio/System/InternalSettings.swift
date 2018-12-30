//
//  InternalSettings.swift
//  MenuRadio
//
//  Created by Ken FUKUHARA on 26/12/2018.
//  Copyright © 2018 Ken FUKUHARA. All rights reserved.
//

import Foundation

//**************************************
// GENERAL SETTINGS
//**************************************

// Display Comments
let kDebugLog = true

//**************************************
// STATION JSON
//**************************************

// If this is set to "true", it will use the JSON file in the app
// Set it to "false" to use the JSON file at the stationDataURL

let useLocalStations = true
let stationDataURL   = "http://yoururl.com/json/stations.json"

//**************************************
// SEARCH BAR
//**************************************

// Set this to "true" to enable the search bar
let searchable = false

//**************************************
// NEXT / PREVIOUS BUTTONS
//**************************************

// Set this to "false" to show the next/previous player buttons
//let hideNextPreviousButtons = true

//**************************************
// ICON NAMES
//**************************************

let iconStopped = "iconStopped"
let iconPlaying = "iconPlaying"
let iconLoading = "iconLoading"
let iconUrlNotSet = "iconUrlNotSet"
let iconError = "iconError"
let AppIcon = "AppIcon"
