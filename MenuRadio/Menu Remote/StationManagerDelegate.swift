//
//  StationManagerDelegate.swift
//  MenuRadio
//
//  Created by Ken FUKUHARA on 09/01/2019.
//  Copyright © 2019 Ken FUKUHARA. All rights reserved.
//

import Foundation
import AppKit

extension MenuRemote: StationManagerDelegate {
    
    func iconNameForStates(_ playerState: FRadioPlayerState, _ playbackState: FRadioPlaybackState) -> String {
        var imageName: String
        
        switch playerState {
        case .error:
            imageName = iconError
        case .loading:
            imageName = iconLoading
        case .loadingFinished, .readyToPlay:
            switch stationManager.player.playbackState {
            case .playing:
                imageName = iconPlaying
            case .paused, .stopped:
                imageName = iconStopped
            }
        case .urlNotSet:
            imageName = iconUrlNotSet
        }
        
        return imageName
    }
    
    func playerStateDidChange(_ playerState: FRadioPlayerState) {
        
        let iconName = iconNameForStates(playerState, stationManager.player.playbackState)
        switchIcon(withImageNamed: iconName, animated: prefs.animatedIcon)
    }
    
    func playbackStateDidChange(_ playbackState: FRadioPlaybackState) {
        
        let iconName = iconNameForStates(stationManager.player.state, playbackState)
        switchIcon(withImageNamed: iconName, animated: prefs.animatedIcon)
    }
    
    func trackDidUpdate(_ track: Track?) {
        popoverController?.updateTrack(track)
    }
    
    func trackArtworkDidUpdate(_ track: Track?) {
        popoverController?.updateTrackArtwork(track)
        
    }
    
}

