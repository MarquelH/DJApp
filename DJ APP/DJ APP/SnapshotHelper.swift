//
//  SnapshotHelper.swift
//  DJ APP
//
//  Created by arturo ho on 12/25/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

class SnapshotHelper: NSObject {

    static let shared = SnapshotHelper()
    
    //Returns a new song object (dictionary of attributes) that has been updated according to the
    //snapshot and value passed in
    func updateTotalvotes(key: String, currentSnapshot: [String: AnyObject], amount: Int) -> [String: AnyObject]{
        
        guard let workingSong = currentSnapshot[key], let upvotes = workingSong["upvotes"] as? Int, let totalvotes = workingSong["totalvotes"] as? Int, let downvotes = workingSong["downvotes"] as? Int, let name = workingSong["name"] as? String, let artist = workingSong["artist"] as? String, let artwork = workingSong["artwork"] as? String, let id = workingSong["id"] as? String, let album = workingSong["album"] as? String, let accepted = workingSong["accepted"] as? Bool else {
            
            //print("Current snapshot is empty.")
            return [:]
        }
        
        let changedScores = changeAllScore(upvotes: upvotes, downvotes: downvotes, totalvotes: totalvotes, amount: amount)
        
        let song = ["id": id, "name":name, "artist":artist,"album": album, "artwork":artwork, "upvotes": changedScores[0], "downvotes":changedScores[1], "totalvotes":changedScores[2], "accepted":accepted] as [String : AnyObject]
        
        return song
    }

    func changeAllScore(upvotes: Int, downvotes: Int, totalvotes: Int, amount: Int) -> [Int] {
        var newTotal: Int = totalvotes
        var newUp: Int = upvotes
        var newDown: Int = downvotes
        
        //down clicked again -> remove down
        if (amount == -3) {
            newTotal = newTotal + 1
            newDown = newDown - 1
        }
            //up clicked again -> remove up
        else if (amount == 3) {
            newTotal = newTotal - 1
            newUp = newUp - 1
        }
            //if amount gt 0 then add amount to upvote, if down then amount number of downvotes
        else if (amount > 0) {
            newUp = newUp + 1
            newTotal = newTotal + amount
            if (amount == 2) {
                newDown = newDown - 1
            }
        }
        else {
            newDown = newDown - 1
            newTotal = newTotal + amount
            if (amount == -2) {
                newUp = newUp - 1
            }
            
        }
        
        return [newUp, newDown, newTotal]
        
    }
    
}
