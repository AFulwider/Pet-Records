//
//  Users.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/11/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit

class User: NSObject {
    var id: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    init(dictionary: [String: Any]) {
        self.id = dictionary["uid"] as? String
        self.firstName = dictionary["firstName"] as? String
        self.lastName = dictionary["lastName"] as? String
        self.email = dictionary["email"] as? String
    }
}
