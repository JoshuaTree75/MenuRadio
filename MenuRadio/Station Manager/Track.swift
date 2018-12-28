//
//  trackswift
//  Swift Radio
//
//  Created by Matthew Fecher on 7/2/15.
//  Copyright (c) 2015 MatthewFecher.com. All rights reserved.
//

import AppKit

//*****************************************************************
// Track struct
//*****************************************************************

struct Track {
	var title: String
	var artist: String
    var artworkImage: NSImage?
    var artworkLoaded = false
    
    init(title: String, artist: String) {
        self.title = title
        self.artist = artist
    }
}
