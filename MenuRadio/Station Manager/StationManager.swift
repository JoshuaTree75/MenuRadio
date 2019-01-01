//
//  StationManager.swift
//  MenuRadio
//
//  Created by Ken FUKUHARA on 26/12/2018.
//  Copyright © 2018 Ken FUKUHARA. All rights reserved.
//

import Cocoa

/**
 The station manager loads stations (name, url, etc.), retains the selected one
 */
class StationManager: NSObject {
    
    //Retain cycle -> explore...
    var delegate: StationManagerDelegate?
    
    let player = FRadioPlayer.shared
        
    var station: RadioStation? {
        didSet {
            resetTrack(with: station)
            player.radioURL = URL(string: station!.streamURL)
        }
    }
    
    private(set) var track: Track?
    
    //*****************************************************************
    // MARK: - Initialization
    //*****************************************************************
    
    override init() {
        super.init()
        player.delegate = self

    }
    
     func resetRadioPlayer() {
        station = nil
        track = nil
        player.radioURL = nil
    }
    


    
    // *****************************************************************
    // MARK: - Track loading/updates
    //*****************************************************************
    
    // Update the track with an artist name and track name
    func updateTrackMetadata(artistName: String, trackName: String) {
        if track == nil {
            track = Track(title: trackName, artist: artistName)
        } else {
            track?.title = trackName
            track?.artist = artistName
        }
        
        delegate?.trackDidUpdate(track)
    }
    
    // Update the track artwork with a NSImage
    func updateTrackArtwork(with image: NSImage, artworkLoaded: Bool) {
        track?.artworkImage = image
        track?.artworkLoaded = artworkLoaded
        delegate?.trackArtworkDidUpdate(track)
    }
    
    // Reset the track metadata and artwork to use the current station infos
    func resetTrack(with station: RadioStation?) {
        guard let station = station else { track = nil; return }
        updateTrackMetadata(artistName: station.desc, trackName: station.name)
        resetArtwork(with: station)
    }
    
    // Reset the track Artwork to current station image
    func resetArtwork(with station: RadioStation?) {
        guard let station = station else { track = nil; return }
        getStationImage(from: station) { image in
            self.updateTrackArtwork(with: image, artworkLoaded: false)
        }
    }
    
    //*****************************************************************
    // MARK: - Private helpers
    //*****************************************************************
    
    private func getStationImage(from station: RadioStation, completionHandler: @escaping (_ image: NSImage) -> ()) {
        
        if station.imageURL.range(of: "http") != nil {
            // load current station image from network
            ImageLoader.sharedLoader.imageForUrl(urlString: station.imageURL) { (image, stringURL) in
                completionHandler(image ?? #imageLiteral(resourceName: "Playing 6"))
            }
        } else {
            // load local station image
            let image = NSImage(named: station.imageURL) ?? #imageLiteral(resourceName: "Playing 6")
            completionHandler(image)
        }
    }
}

extension StationManager: FRadioPlayerDelegate {
    
    func radioPlayer(_ player: FRadioPlayer, playerStateDidChange state: FRadioPlayerState) {
        if kDebugLog { print("playerStateDidChange: \(state)") }
        delegate?.playerStateDidChange(state)
    }
    
    func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlaybackState) {
        if kDebugLog { print("playbackStateDidChange: \(state)") }
        delegate?.playbackStateDidChange(state)
    }
    
    func radioPlayer(_ player: FRadioPlayer, metadataDidChange artistName: String?, trackName: String?) {
        guard
            let artistName = artistName, !artistName.isEmpty,
            let trackName = trackName, !trackName.isEmpty else {
                resetTrack(with: station)
                return
        }
        updateTrackMetadata(artistName: artistName, trackName: trackName)
    }
    
    func radioPlayer(_ player: FRadioPlayer, artworkDidChange artworkURL: URL?) {
        guard let artworkURL = artworkURL else { resetArtwork(with: station); return }
        
        ImageLoader.sharedLoader.imageForUrl(urlString: artworkURL.absoluteString) { (image, stringURL) in
            guard let image = image else { self.resetArtwork(with: self.station); return }
            self.updateTrackArtwork(with: image, artworkLoaded: true)
        }
    }
}

//*****************************************************************
// StationManagerDelegate: Sends FRadioPlayer and Station/Track events
//*****************************************************************

protocol StationManagerDelegate {
    //func stationsDidUpdate()
    //func statesDidChange(_ playerState: FRadioPlayerState, _ playbackState: FRadioPlaybackState)
    func playerStateDidChange(_ playerState: FRadioPlayerState)
    func playbackStateDidChange(_ playbackState: FRadioPlaybackState)
    func trackDidUpdate(_ track: Track?)
    func trackArtworkDidUpdate(_ track: Track?)
}
