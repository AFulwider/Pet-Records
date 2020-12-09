//
//  AddPetViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/20/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class AddPetViewController: UIViewController {
    
    let nameTextField = UITextField()
    let breedTextField = UITextField()
    let dateOfBirthTextField = UITextField()
    let genderTextField = UITextField()
    let submitButton = SignInButtonCustom()
    let cancelButton = SignInButtonCustom()
    let profileImageView = UIImageView()
    
    let dobDatePicker : UIDatePicker = {
        let picker = UIDatePicker.init()
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var minComponents = DateComponents()
        minComponents.calendar = calendar
        minComponents.year = -20
        var maxComponents = DateComponents()
        maxComponents.calendar = calendar
        maxComponents.year = 1
        let minDate = calendar.date(byAdding: minComponents, to: currentDate)
        let maxDate = calendar.date(byAdding: maxComponents, to: currentDate)
        picker.datePickerMode = .date
        picker.minimumDate = minDate
        picker.maximumDate = maxDate
        picker.addTarget(self, action: #selector(dateValueChanged), for: .valueChanged)
        return picker
    }()
    
    @objc func dateValueChanged(_ sender: UIDatePicker){
        let string = DateHelper.dateToString("MMMM dd, yyyy", sender.date)
        dateOfBirthTextField.text = string
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI(){
        view.addSubview(profileImageView)
        view.addSubview(nameTextField)
        view.addSubview(breedTextField)
        view.addSubview(dateOfBirthTextField)
        view.addSubview(genderTextField)
        view.addSubview(submitButton)
        view.addSubview(cancelButton)
        
        nameTextField.delegate = self
        breedTextField.delegate = self
        dateOfBirthTextField.delegate = self
        genderTextField.delegate = self
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        breedTextField.translatesAutoresizingMaskIntoConstraints = false
        dateOfBirthTextField.translatesAutoresizingMaskIntoConstraints = false
        genderTextField.translatesAutoresizingMaskIntoConstraints = false
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        addToolBar(textField: nameTextField)
        addToolBar(textField: breedTextField)
        addToolBar(textField: dateOfBirthTextField)
        addToolBar(textField: genderTextField)
        
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        profileImageView.image = UIImage(named: "blank_profile_image")
        profileImageView.contentMode = .scaleAspectFit
        
        Utilities.styleTextFields(textfield: nameTextField, placeholder: "Name", secureTextEntry: false)
        nameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        nameTextField.textAlignment = .center
        
        Utilities.styleTextFields(textfield: breedTextField, placeholder: "Breed", secureTextEntry: false)
        breedTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10).isActive = true
        breedTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        breedTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        breedTextField.textAlignment = .center
        
        // TODO: CHANGE TO TOGGLE
        Utilities.styleTextFields(textfield: genderTextField, placeholder: "Gender", secureTextEntry: false)
        genderTextField.topAnchor.constraint(equalTo: breedTextField.bottomAnchor, constant: 10).isActive = true
        genderTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        genderTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        genderTextField.textAlignment = .center
        
        Utilities.styleTextFields(textfield: dateOfBirthTextField, placeholder: "DoB", secureTextEntry: false)
        dateOfBirthTextField.topAnchor.constraint(equalTo: breedTextField.bottomAnchor, constant: 10).isActive = true
        dateOfBirthTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        dateOfBirthTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        dateOfBirthTextField.textAlignment = .center
        dateOfBirthTextField.inputView = dobDatePicker
        
        submitButton.topAnchor.constraint(equalTo: dateOfBirthTextField.bottomAnchor, constant: 20).isActive = true
        submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        
        cancelButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 10).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    @objc func doneButtonTapped() {
        dateOfBirthTextField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 16
    }
    
    @objc func cancelButtonTapped() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func submitButtonTapped() {
        let name   = nameTextField.text!
        let breed    = breedTextField.text!
        let age       = dateOfBirthTextField.text!
        let gender       = genderTextField.text!
        
        if name != "" && breed != "" && age != "" && gender != "" {
            // Real-time database
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("pet_profile_images").child("\(imageName).png")
            if let uploadData = self.profileImageView.image!.pngData() {
                storageRef.putData(uploadData, metadata: nil, completion:  { (metadata, error) in
                    if (error != nil) {
                        return
                    }
                    storageRef.downloadURL { (url, error) in
                        if let profileImageURL = url?.absoluteString {
                            let uid = Auth.auth().currentUser?.uid
                            let ref = Database.database().reference().child("user_pets").child(uid!)
                            let childRef = ref.childByAutoId()
                            let values = ["pid": childRef.key!,"gender": gender, "name": name, "breed": breed, "dob": age, "pet_profile_Image": profileImageURL]
                            DispatchQueue.main.async(execute: {
                                childRef.updateChildValues(values)
                            })
                        }
                    }
                })
            }
        }
        _ = navigationController?.popViewController(animated: true)
    }
}

