//
//  GroomingNSObject.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/22/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit

class GroomingNSObject: NSObject {
    var title : String?
    var groomId : String?
    var detailText : String?
    var groomDate : String?
    init(dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String
        self.groomId = dictionary["groom_id"] as? String
        self.groomDate = dictionary["time"] as? String
    }
}
