//
//  Appointments.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/20/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit

class Appointment:NSObject {
    var appId:String?
    var title:String?
    var time:String?
    var location:String?
    var petName:String?
    init(dictionary: [String: Any]) {
        self.appId = dictionary["app_id"] as? String
        self.title = dictionary["title"] as? String
        self.time = dictionary["time"] as? String
        self.location = dictionary["location"] as? String
        self.petName = dictionary["pet_name"] as? String
    }
}

