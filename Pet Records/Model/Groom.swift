//
//  GroomingNSObject.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/22/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit

class Groom: NSObject {
    var title : String?
    var descriptionString : String?
    var time : String?
    var id : String?
    init(dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String
        self.descriptionString = dictionary["description"] as? String
        self.time = dictionary["time"] as? String
        self.id = dictionary["id"] as? String
    }
}
