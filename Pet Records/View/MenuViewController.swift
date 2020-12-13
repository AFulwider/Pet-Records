//
//  MenuViewController.swift
//  Pet Records
//
//  Created by Monideepa Sengupta on 12/10/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit

class MenuViewController: UIView {
    let titleLabel = UILabel()
    let appointmentsButton = UIButton()
    let userProfileButton = UIButton()
    let emergencyButton = UIButton()
    let mapsButton = UIButton()
    
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(titleLabel)
        addSubview(stackView)
        stackView.addArrangedSubview(appointmentsButton)
        stackView.addArrangedSubview(userProfileButton)
        stackView.addArrangedSubview(mapsButton)
        stackView.addArrangedSubview(emergencyButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        appointmentsButton.translatesAutoresizingMaskIntoConstraints = false
        userProfileButton.translatesAutoresizingMaskIntoConstraints = false
        mapsButton.translatesAutoresizingMaskIntoConstraints = false
        emergencyButton.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.text = "TITLE"
        titleLabel.backgroundColor = .systemTeal
        
        stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        
        appointmentsButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        appointmentsButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        appointmentsButton.backgroundColor = .systemRed
        appointmentsButton.layer.cornerRadius = 8
        
        userProfileButton.heightAnchor.constraint(equalToConstant: 10).isActive = true
        userProfileButton.widthAnchor.constraint(equalToConstant: 10).isActive = true
        userProfileButton.backgroundColor = .systemGray3
        userProfileButton.layer.cornerRadius = 8
        
        mapsButton.heightAnchor.constraint(equalToConstant: 90).isActive = true
        mapsButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        mapsButton.backgroundColor = .systemGreen
        mapsButton.layer.cornerRadius = 8
        
        emergencyButton.heightAnchor.constraint(equalToConstant: 200).isActive = true
        emergencyButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        emergencyButton.backgroundColor = .systemPurple
        emergencyButton.layer.cornerRadius = 8
    }
}
