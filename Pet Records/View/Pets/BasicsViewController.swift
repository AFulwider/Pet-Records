//
//  BasicsViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 12/15/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class BasicsViewController: UIViewController {
    
    var pet : Pet?
    
    let introLabel = UILabel()
    
    let vertStackView = UIStackView()
    let medTextView = UITextView() // names and doses
    let foodTextView = UITextView() // food they eat
    let habitsTextView = UITextView() // eating and drinking habits
    let toiletTextView = UITextView() // poop habits
    let bitesTextView = UITextView() // bites
    let historyTextView = UITextView() // medical history
    
    func fetchBasics() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).child("pets").child((pet?.pid)!).child("Basics").observe(.value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let basics = Basics(dict: dictionary)
                DispatchQueue.main.async(execute: {
                    self.medTextView.text = basics.medication
                    self.foodTextView.text = basics.food
                    self.habitsTextView.text = basics.eating
                    self.toiletTextView.text = basics.toilet
                    self.bitesTextView.text = basics.bites
                    self.historyTextView.text = basics.history
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        setupUI()
        fetchBasics()
    }
    
    @objc func editTapped() {
        if vertStackView.isUserInteractionEnabled {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
            vertStackView.isUserInteractionEnabled = false
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveEdit))
            vertStackView.isUserInteractionEnabled = true
        }
    }
    
    func setupUI() {
        let toolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let submit  = UIBarButtonItem(title: "DONE", style: .done, target: self, action: #selector(doneButtonTapped))
        let items = [flexSpace, submit]
        toolBar.items = items
        toolBar.sizeToFit()
        
        view.addSubview(introLabel)
        introLabel.translatesAutoresizingMaskIntoConstraints = false
        introLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        introLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        introLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        introLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        introLabel.numberOfLines = 2
        introLabel.adjustsFontSizeToFitWidth = true
        introLabel.textAlignment = .left
        introLabel.font = UIFont(name: "Arial-BoldMT", size: 40)
        introLabel.text = "This is where you will enter your pet's basic information.\n(Questions your vet will likely ask you on a first visit)"
        
        view.addSubview(vertStackView)
        vertStackView.translatesAutoresizingMaskIntoConstraints = false
        vertStackView.topAnchor.constraint(equalTo: introLabel.bottomAnchor).isActive = true
        vertStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        vertStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        vertStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        vertStackView.distribution = .fillEqually
        vertStackView.axis = .vertical
        vertStackView.spacing = 4
        vertStackView.isUserInteractionEnabled = false
        
        vertStackView.addArrangedSubview(medTextView)
        medTextView.translatesAutoresizingMaskIntoConstraints = false
        
        vertStackView.addArrangedSubview(foodTextView)
        foodTextView.translatesAutoresizingMaskIntoConstraints = false
        
        vertStackView.addArrangedSubview(habitsTextView)
        habitsTextView.translatesAutoresizingMaskIntoConstraints = false
        
        vertStackView.addArrangedSubview(toiletTextView)
        toiletTextView.translatesAutoresizingMaskIntoConstraints = false
        
        vertStackView.addArrangedSubview(bitesTextView)
        bitesTextView.translatesAutoresizingMaskIntoConstraints = false
        
        vertStackView.addArrangedSubview(historyTextView)
        historyTextView.translatesAutoresizingMaskIntoConstraints = false
        
        medTextView.layer.borderWidth = 1
        medTextView.layer.borderColor = UIColor.black.cgColor
        medTextView.text = "Medication"
        medTextView.inputAccessoryView = toolBar
        
        foodTextView.layer.borderWidth = 1
        foodTextView.layer.borderColor = UIColor.black.cgColor
        foodTextView.text = "Food"
        foodTextView.inputAccessoryView = toolBar
        
        habitsTextView.layer.borderWidth = 1
        habitsTextView.layer.borderColor = UIColor.black.cgColor
        habitsTextView.text = "Eating Habits"
        habitsTextView.inputAccessoryView = toolBar
        
        toiletTextView.layer.borderWidth = 1
        toiletTextView.layer.borderColor = UIColor.black.cgColor
        toiletTextView.text = "Toilet Habits"
        toiletTextView.inputAccessoryView = toolBar
        
        bitesTextView.layer.borderWidth = 1
        bitesTextView.layer.borderColor = UIColor.black.cgColor
        bitesTextView.text = "Recent tick/flea bites?"
        bitesTextView.inputAccessoryView = toolBar
        
        historyTextView.layer.borderWidth = 1
        historyTextView.layer.borderColor = UIColor.black.cgColor
        historyTextView.text = "Vaccination History"
        historyTextView.inputAccessoryView = toolBar
    }
    
    @objc func saveEdit() {
        let uid = Auth.auth().currentUser?.uid
        let medText = medTextView.text
        let foodText = foodTextView.text
        let habitText = habitsTextView.text
        let toiletText = toiletTextView.text
        let biteText = bitesTextView.text
        let historyText = historyTextView.text
         
        let ref = Database.database().reference().child("users").child(uid!).child("pets").child((pet?.pid)!).child("Basics")
        let values = ["medication": medText, "food": foodText, "eating": habitText, "toilet": toiletText, "bites": biteText, "history": historyText]
        DispatchQueue.main.async(execute: { ref.updateChildValues(values as [String:AnyObject]) })
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
}
