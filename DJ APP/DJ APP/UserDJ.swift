//
//  UserDJ.swift
//  DJ APP
//
//  Created by arturo ho on 9/16/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class UserDJ: NSObject {
    var age: Int?
    var currentLocation: String?
    var djName: String?
    var email: String?
    var genre: String?
    var hometown: String?
    var validated: Bool?
    var profilePicURL: String?
    var uid: String?
    
    init(age: Int, currentLocation: String, djName: String, email: String, genre: String, hometown: String, validated: Bool, profilePicURL: String, uid: String) {
        self.age = age
        self.currentLocation = currentLocation
        self.djName = djName
        self.email = email
        self.genre = genre
        self.hometown = hometown
        self.validated = validated
        self.profilePicURL = profilePicURL
        self.uid = uid
    }
    
}
