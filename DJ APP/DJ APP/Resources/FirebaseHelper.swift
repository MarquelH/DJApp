//
//  FirebaseHelper.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 3/28/20.
//  Copyright © 2020 Marquel and Micajuine App Team. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FirebaseHelper {
    //static var eventSnapshot: [String: AnyObject]?
    
    func addEventToDB() {
        
    }
    
    static func isFound(eventDateAndTime: String, djName: String?, eventSnapshot: [String: AnyObject]?) ->(found: Bool, key: String, realDate: String) {
        if let workingSnap = eventSnapshot {
            for (k,v) in workingSnap {
                
                if let dateAndTime = v["StartDateAndTime"] as? String{
                    let dateAloneArray = dateAndTime.split(separator: ",")
                    let dateForComparison = dateAloneArray[0]
                    let realDate = String(dateForComparison)
                    let theName = v["DJ Name"] as! String
                    if theName == djName {
                        if realDate == eventDateAndTime {
                            return (true, k, realDate)
                        }
                    }
                }
            }
        }
        else {
            //print("Snap did not load")
        }
        return (false, "","")
    }
    
    static func addEventWithKey(key: String, dj: UserDJ?, location: String, startDate: String, endDate: String, lat: String, long: String, refEventList: DatabaseReference) {
        if let djName = dj?.djName, let djUID = dj?.uid {
            
            let event = ["id": key, "location":location , "StartDateAndTime": startDate,"DjID":djUID,
                         "EndDateAndTime":endDate,"Latitude Coordinates": lat,"Longitude Coordinates":long,"DJ Name":djName] as [String : Any]
            
            refEventList.child(key).setValue(event)
            //presentAlertForAdd(title: "Success!", error: "We have added your event to the calendar!")
            
        }
        else {
            //print("One of the fields is not present.")
        }
    }
}
