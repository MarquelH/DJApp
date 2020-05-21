//
//  DJs+CoreDataProperties.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 8/26/19.
//  Copyright © 2019 Marquel and Micajuine App Team. All rights reserved.
//
//

import Foundation
import CoreData


extension DJs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DJs> {
        return NSFetchRequest<DJs>(entityName: "DJs")
    }

    @NSManaged public var djName: String?
    @NSManaged public var age: Int
    @NSManaged public var currentLocation: String?
    @NSManaged public var email: String?
    @NSManaged public var genre: String?
    @NSManaged public var hometown: String?
    @NSManaged public var profilePicURL: String?
    @NSManaged public var uid: String?
    @NSManaged public var twitter: String?

}
