//
//  Food.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 12/20/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit

class Food: NSObject {
    var title: String?
//    var habits:String?
    var descriptionString: String?
    var id: String?
    init(dictionary: [String:AnyObject]) {
        self.title = dictionary["title"] as? String
//        self.habits = dict["habits"] as? String
        self.descriptionString = dictionary["description"] as? String
        self.id = dictionary["id"] as? String
    }
}
