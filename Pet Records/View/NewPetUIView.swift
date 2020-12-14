//
//  NewPetUIView.swift
//  Pet Records
//
//  Created by Monideepa Sengupta on 12/13/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit

class NewPetUIView: UIView {

    let title = UILabel()
    
    let picView = UIView()
    let profilePic1 = UIImageView()
    let profilePic2 = UIImageView()
    let profilePic3 = UIImageView()
    let profilePic4 = UIImageView()
    
    let petNameTextField = UITextField()
    let petNameTextField2 = UITextField()
    
    let submitButton = UIButton()
    let cancelButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(title)
        addSubview(picView)
        picView.addSubview(profilePic1)
        picView.addSubview(profilePic2)
        picView.addSubview(profilePic3)
        picView.addSubview(profilePic4)
        addSubview(petNameTextField)
        addSubview(petNameTextField2)
        addSubview(submitButton)
        addSubview(cancelButton)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        picView.translatesAutoresizingMaskIntoConstraints = false
        profilePic1.translatesAutoresizingMaskIntoConstraints = false
        profilePic2.translatesAutoresizingMaskIntoConstraints = false
        profilePic3.translatesAutoresizingMaskIntoConstraints = false
        profilePic4.translatesAutoresizingMaskIntoConstraints = false
        petNameTextField.translatesAutoresizingMaskIntoConstraints = false
        petNameTextField2.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        title.topAnchor.constraint(equalTo: topAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        title.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        title.backgroundColor = .systemBlue
        title.text = "New Pet"
        
        picView.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        picView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        picView.trailingAnchor.constraint(equalTo: centerXAnchor).isActive = true
        picView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
        picView.backgroundColor = .systemTeal
        
        profilePic1.topAnchor.constraint(equalTo: picView.topAnchor).isActive = true
        profilePic1.leadingAnchor.constraint(equalTo: picView.leadingAnchor).isActive = true
        profilePic1.trailingAnchor.constraint(equalTo: picView.centerXAnchor).isActive = true
        profilePic1.bottomAnchor.constraint(equalTo: picView.centerYAnchor).isActive = true
        profilePic1.backgroundColor = .systemGray
        
        profilePic2.topAnchor.constraint(equalTo: picView.topAnchor).isActive = true
        profilePic2.leadingAnchor.constraint(equalTo: picView.centerXAnchor).isActive = true
        profilePic2.trailingAnchor.constraint(equalTo: picView.trailingAnchor).isActive = true
        profilePic2.bottomAnchor.constraint(equalTo: picView.centerYAnchor).isActive = true
        profilePic2.backgroundColor = .systemGray2
        
        profilePic3.topAnchor.constraint(equalTo: picView.centerYAnchor).isActive = true
        profilePic3.leadingAnchor.constraint(equalTo: picView.leadingAnchor).isActive = true
        profilePic3.trailingAnchor.constraint(equalTo: picView.centerXAnchor).isActive = true
        profilePic3.bottomAnchor.constraint(equalTo: picView.bottomAnchor).isActive = true
        profilePic3.backgroundColor = .systemGray3
        
        profilePic4.topAnchor.constraint(equalTo: picView.centerYAnchor).isActive = true
        profilePic4.leadingAnchor.constraint(equalTo: picView.centerXAnchor).isActive = true
        profilePic4.trailingAnchor.constraint(equalTo: picView.trailingAnchor).isActive = true
        profilePic4.bottomAnchor.constraint(equalTo: picView.bottomAnchor).isActive = true
        profilePic4.backgroundColor = .systemGray4
        
        petNameTextField.topAnchor.constraint(equalTo: picView.topAnchor).isActive = true
        petNameTextField.leadingAnchor.constraint(equalTo: picView.trailingAnchor).isActive = true
        petNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        petNameTextField.bottomAnchor.constraint(equalTo: picView.centerYAnchor).isActive = true
        petNameTextField.backgroundColor = .systemYellow
        petNameTextField.placeholder = "Name"
        
        petNameTextField2.topAnchor.constraint(equalTo: petNameTextField.bottomAnchor).isActive = true
        petNameTextField2.leadingAnchor.constraint(equalTo: picView.trailingAnchor).isActive = true
        petNameTextField2.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        petNameTextField2.bottomAnchor.constraint(equalTo: picView.bottomAnchor).isActive = true
        petNameTextField2.backgroundColor = .systemPink
        petNameTextField2.placeholder = "Breed"
        
        cancelButton.topAnchor.constraint(equalTo: picView.bottomAnchor).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        cancelButton.backgroundColor = .systemRed
        
        submitButton.topAnchor.constraint(equalTo: picView.bottomAnchor).isActive = true
        submitButton.leadingAnchor.constraint(equalTo: centerXAnchor).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        submitButton.backgroundColor = .systemGreen
        
    }
}
