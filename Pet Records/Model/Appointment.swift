//
//  Appointments.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/20/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit

class Appointment:NSObject {
    var title:String?
    var descriptionString:String?
    var time:String?
    var location:String?
    init(dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String
        self.descriptionString = dictionary["description"] as? String
        self.time = dictionary["time"] as? String
        self.location = dictionary["location"] as? String
    }
}

