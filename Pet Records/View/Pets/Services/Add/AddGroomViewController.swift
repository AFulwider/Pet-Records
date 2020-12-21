//
//  AddGroomViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 12/19/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class AddGroomViewController : UIViewController {
    
    let titleLabel = UILabel()
    let whereTextField = UITextField()
    let descriptionTextView = UITextView()
    let whenTextField = UITextField()
    let saveButton = UIButton()
    
    var pet : Pet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleLabel.font = UIFont(name: "", size: 40)
        titleLabel.text = "Add a grooming appointment for \(pet?.name ?? "Benji")."
        titleLabel.numberOfLines = 0
        
        view.addSubview(whereTextField)
        whereTextField.translatesAutoresizingMaskIntoConstraints = false
        whereTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2).isActive = true
        whereTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        whereTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        whereTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        whereTextField.layer.borderWidth = 1
        whereTextField.layer.borderColor = UIColor.black.cgColor
        whereTextField.placeholder = "Location"
        
        view.addSubview(descriptionTextView)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.topAnchor.constraint(equalTo: whereTextField.bottomAnchor, constant: 2).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        descriptionTextView.text = "Details: "
        
        view.addSubview(whenTextField)
        whenTextField.translatesAutoresizingMaskIntoConstraints = false
        whenTextField.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 2).isActive = true
        whenTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        whenTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        whenTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        whenTextField.layer.borderWidth = 1
        whenTextField.layer.borderColor = UIColor.black.cgColor
        whenTextField.placeholder = DateHelper.shared.todaysDate()
    }
    
    @objc func doneButtonTapped() {
        
    }
}
