//
//  HeaderLabel.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/21/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit

class HeaderLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        setShadow()
        textColor = .black
        font    = UIFont(name: "Chalkboard SE", size: 26)
        adjustsFontSizeToFitWidth = true
    }
    
    private func setShadow(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.5
        clipsToBounds = true
        layer.masksToBounds = false
    }
}
