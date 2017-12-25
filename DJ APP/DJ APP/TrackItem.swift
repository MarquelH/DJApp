//
//  TrackItem.swift
//  DJ APP
//
//  Created by arturo ho on 11/13/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import Foundation

struct TrackItem {
    
    var trackName: String?
    var trackArtist: String?
    
    var trackImage: URL?
    var upvotes: Int?
    var downvotes: Int?
    var totalvotes: Int?
    var id: String?
    
    init(trackName: String, trackArtist: String, trackImage: URL) {
        self.trackName = trackName
        self.trackArtist = trackArtist
        self.trackImage = trackImage
        id = ""
        upvotes = 0
        downvotes = 0
        totalvotes = 0
        
    }
    
    init() {
        
    }
    
}
