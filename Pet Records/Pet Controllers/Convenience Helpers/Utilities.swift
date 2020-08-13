//
//  Utilities.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 1/30/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    static func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func styleTextFields(textfield:UITextField, placeholder:String, secureTextEntry:Bool){
//        let frameHeight = 40
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        textfield.backgroundColor     = Colors.lightGray.withAlphaComponent(0.95)
        textfield.font    = UIFont(name: "ChalkboardSE-Bold", size: 24)
        textfield.adjustsFontSizeToFitWidth = true
        textfield.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textfield.layer.cornerRadius  = 15
        textfield.layer.borderWidth   = 1
        textfield.layer.borderColor   = UIColor.darkGray.cgColor
        textfield.textAlignment = .center
        textfield.placeholder = placeholder
        textfield.isSecureTextEntry = secureTextEntry
        textfield.layer.addSublayer(bottomLine)
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.textColor = .black
        textfield.layer.shadowColor   = UIColor.black.cgColor
        textfield.layer.shadowOffset  = CGSize(width: 0.0, height: 6.0)
        textfield.layer.shadowRadius  = 8
        textfield.layer.shadowOpacity = 0.5
        textfield.clipsToBounds       = true
        textfield.layer.masksToBounds = false
    }
    
    static func errorTextFields(_ label:UILabel){
        label.text             = "Error Label"
        label.textAlignment    = .center
        label.textColor        = .red
    }
}
