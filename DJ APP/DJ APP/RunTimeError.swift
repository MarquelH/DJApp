//
//  RunTimeError.swift
//  DJ APP
//
//  Created by arturo ho on 12/24/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import Foundation

struct RunTimeError: Error {
    
    let messasge: String

    init(message: String) {
        self.messasge = message
    }
    
    public var localizedDescription: String {
        return messasge
    }
    
    //In protocol     func getSearchDJ() throws -> UserDJ

    
    //function that throws
//    func getSearchDJ() throws -> UserDJ {
//        guard let searchDj = self.dj  else {
//            throw RunTimeError(message: "Search DJ is empty")
//        }
//        print("search dj to be send is: \(searchDj.djName)")
//        return searchDj
//    }
    
    //How to call
    //        do {
    //            try dj = delegate?.getSearchDJ()
    //        }
    //        catch let message {
    //            print(message)
    //        }
    //
}
