//
//  Basics.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 12/15/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class Basics: NSObject {
    var medication: String?
    var food: String?
    var eating: String?
    var toilet: String?
    var bites: String?
    var history:String?
    
    init(dict: [String:AnyObject]) {
        self.medication = dict["medication"] as? String
        self.food = dict["food"] as? String
        self.eating = dict["eating"] as? String
        self.toilet = dict["toilet"] as? String
        self.bites = dict["bites"] as? String
        self.history = dict["history"] as? String
    }
}
