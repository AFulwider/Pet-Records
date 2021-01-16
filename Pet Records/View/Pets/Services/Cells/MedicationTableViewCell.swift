//
//  MedicationTableviewCell.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 12/30/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit

class MedicationTableViewCell:UITableViewCell {
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        uiSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func uiSetup(){
        addSubview(titleLabel)
        addSubview(descriptionLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints  = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: (frame.width/2)).isActive = true
        titleLabel.adjustsFontSizeToFitWidth = true
        
        descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 2).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        descriptionLabel.widthAnchor.constraint(equalToConstant: (frame.width/4)).isActive = true
        descriptionLabel.adjustsFontSizeToFitWidth = true
    }
}
