//
//  Event.swift
//  DJ APP
//
//  Created by arturo ho on 1/7/18.
//  Copyright © 2018 Marquel and Micajuine App Team. All rights reserved.
//

import Foundation

class Event: NSObject {
    var djID: String?
    var location: String?
    var startTime: Date?
    var endTime: Date?
    var eventID: String?
    var djName: String?
    
    init(djID: String, location: String, startTime: Date, endTime: Date, eventID: String) {
        self.djID = djID
        self.location = location
        self.startTime = startTime
        self.endTime = endTime
        self.eventID = eventID
    }
    
    init(djID: String, location: String, startTime: Date, endTime: Date, eventID: String, djName: String) {
        self.djID = djID
        self.location = location
        self.startTime = startTime
        self.endTime = endTime
        self.eventID = eventID
        self.djName = djName
    }
}
