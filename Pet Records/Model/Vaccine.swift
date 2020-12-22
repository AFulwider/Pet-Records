//
//  Vaccine.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/22/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit

class Vaccine: NSObject {
    var title: String?
    var vacDate: String?
    var id:String?
    init(dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String
        self.vacDate = dictionary["date"] as? String
        self.id = dictionary["id"] as? String    }
}
