//
//  Medication.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 12/20/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class Medication: NSObject {
    var title: String?
    var descriptionString: String?
    init(dict: [String:AnyObject]) {
        self.title = dict["title"] as? String
        self.descriptionString = dict["description"] as? String
    }
}
