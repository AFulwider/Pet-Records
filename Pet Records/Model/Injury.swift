//
//  Injury.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 12/20/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit

class Injury:NSObject {
    var title: String?
    var descriptionString: String?
    var id:String?
    init(dictionary: [String:AnyObject]) {
        self.title = dictionary["title"] as? String
        self.descriptionString = dictionary["description"] as? String
        self.id = dictionary["id"] as? String
    }
}
