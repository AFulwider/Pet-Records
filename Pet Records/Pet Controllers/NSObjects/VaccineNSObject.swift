//
//  Vaccine.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/22/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit

class VaccineNSObject: NSObject {
    var vacId : String?
    var title: String?
    var startDate: String?
    var endDate: String?
    init(dictionary: [String: Any]) {
        self.vacId = dictionary["vac_id"] as? String
        self.title = dictionary["title"] as? String
        self.startDate = dictionary["start_time"] as? String
        self.endDate = dictionary["end_time"] as? String
    }
}
