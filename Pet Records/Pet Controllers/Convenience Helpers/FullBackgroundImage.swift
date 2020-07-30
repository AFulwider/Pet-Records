//
//  FullBackgroundImage.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 6/2/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import Foundation
import UIKit

class FullBackgroundImage: UIView {
    
    var image : UIImage?
    let backgroundImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 100, width: 200, height: 200))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupButton()
    }
    
    func setupButton(){
        backgroundImage.contentMode = ContentMode.scaleAspectFill
        frame = bounds
        self.backgroundImage.image = image
        self.addSubview(backgroundImage)
        backgroundColor     = Colors.darkPurple
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}


//        backgroundColor = UIColor(patternImage: image!)
