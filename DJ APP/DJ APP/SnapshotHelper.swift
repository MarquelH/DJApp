//
//  SnapshotHelper.swift
//  DJ APP
//
//  Created by arturo ho on 12/25/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class SnapshotHelper: NSObject {

    static let shared = SnapshotHelper()
    
    //Returns a new song object (dictionary of attributes) that has been updated according to the
    //snapshot and value passed in
    func updateTotalvotes(key: String, currentSnapshot: [String: AnyObject], num: Int) -> [String: AnyObject]{
        
        guard let workingSong = currentSnapshot[key], var upvotes = workingSong["upvotes"] as? Int, var totalvotes = workingSong["totalvotes"] as? Int, var downvotes = workingSong["downvotes"] as? Int, let name = workingSong["name"] as? String, let artist = workingSong["artist"] as? String, let artwork = workingSong["artwork"] as? String, let id = workingSong["id"] as? String else {
            
            print("Current snapshot is empty.")
            return [:]
        }
        
        //if 1 then add an upvote, if down then add a downvote
        if (num == 1) {
            upvotes = upvotes + 1
            totalvotes = totalvotes + 1
        }
        else {
            downvotes = downvotes + 1
            totalvotes = totalvotes - 1
        }
        
        let song = ["id": id, "name":name, "artist":artist, "artwork":artwork, "upvotes": upvotes, "downvotes":downvotes, "totalvotes":totalvotes] as [String : AnyObject]
        
        return song
        
    }
}
