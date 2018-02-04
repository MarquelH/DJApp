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
    var trackAlbum: String?
    var trackImage: URL?
    var upvotes: Int?
    var downvotes: Int?
    var totalvotes: Int?
    var id: String?
    var accepted: String?
    
    init(trackName: String, trackArtist: String, trackImage: URL, trackAlbum: String) {
        self.trackName = trackName
        self.trackArtist = trackArtist
        self.trackImage = trackImage
        self.trackAlbum = trackAlbum
        id = ""
        upvotes = 0
        downvotes = 0
        totalvotes = 0
    }
    
    init() {
    }
    
    init(trackName: String, trackArtist: String, trackImage: String, id: String, upvotes: Int, downvotes: Int, totalvotes: Int, trackAlbum: String) {
        self.trackName = trackName
        self.trackArtist = trackArtist
        self.id = id
        self.upvotes = upvotes
        self.downvotes = downvotes
        self.totalvotes = totalvotes
        let trackImageURL = URL.init(string: trackImage)
        self.trackImage = trackImageURL
        self.trackAlbum = trackAlbum
    }
    
}
