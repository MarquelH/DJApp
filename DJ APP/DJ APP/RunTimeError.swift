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
  
}
