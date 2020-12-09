//
//  CustomButton.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 3/26/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit

class SignInButtonCustom: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton(){
        setShadow()
        setTitleColor(.white, for: .normal)
        backgroundColor     = Colors.mediumBlue
        titleLabel?.font    = UIFont(name: "Avenir-Book", size: 24)
        setTitleColor(Colors.darkBrown, for: .normal)
        titleLabel?.adjustsFontSizeToFitWidth = true
        heightAnchor.constraint(equalToConstant: 44).isActive = true
        layer.cornerRadius  = 15
        layer.borderWidth   = 1
        layer.borderColor   = UIColor.darkGray.cgColor // add a color for this in Constants.swift doesn't have to be darkgray
    }
    
    private func setShadow(){
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius  = 8
        layer.shadowOpacity = 0.5
        clipsToBounds       = true
        layer.masksToBounds = false
    }
}
