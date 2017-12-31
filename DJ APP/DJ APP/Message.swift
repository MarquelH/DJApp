//
//  Message.swift
//  DJ APP
//
//  Created by arturo ho on 12/30/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class Message: NSObject {
    var message: String?
    var timeStamp: NSNumber?
    var djUID: String?
    var guestID: String?
    
    init(message: String, timeStamp: NSNumber, djUID: String, guestID: String) {
        self.message = message
        self.timeStamp = timeStamp
        self.djUID = djUID
        self.guestID = guestID
    }
    
}
