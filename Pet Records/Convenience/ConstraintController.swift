//
//  ConstraintController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 6/5/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import Foundation
import UIKit

class ConstraintController {
    
    static func setLayoutConstraints(frame: CGRect, topConstraint: NSLayoutConstraint, bottomConstraint: NSLayoutConstraint, leftConstraint: NSLayoutConstraint, rightConstraint: NSLayoutConstraint, view : UIView) -> CGRect {
        var rekt : CGRect?
        rekt = CGRect(x: 0, y: 0, width: 0, height: 0)
//        view.topAnchor.constraint(equalTo: topConstraint)
        _ = view.safeAreaInsets.top
        _ = view.safeAreaInsets.bottom
        return rekt!
    }
}
