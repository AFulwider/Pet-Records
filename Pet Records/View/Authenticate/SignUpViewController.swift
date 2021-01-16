//
//  SignUpViewController.swift
//  Pet Records
/*
 This is the registration View Controller, which will allow the user to create an
 account for Pet-Records.
 Contents:
 first name textfield
 last name textfield
 email textfield
 password textfield
 submit button
 cancel button
 
 Todo: create optional profile image button to give the user a chance to set a profile image
 for themself.
 */
//  Created by Aaron Fulwider on 1/30/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import CloudKit

class SignUpViewController: UIViewController, UINavigationControllerDelegate {
    
    var homeScreenController = HomeScreenViewController()
    
    let mainStackView = UIStackView()
    let buttonStackView = UIStackView()
    
    let firstNameTextField = UITextField()
    let lastNameTextField = UITextField()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    
    let backgroundImageView = UIImageView()
    
    let submitButton = SignInButtonCustom()
    let cancelButton = SignInButtonCustom()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    var vacViewHeight : NSLayoutConstraint?
    var firstNameHeight : NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "SignUpViewController"
        uiSetup()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    //TODO: - STILL TRYING TO FIGURE OUT FIRESTORE()
    @objc func signUpTapped() {
        let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Authenticate
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in // Create User
            guard let uid = result?.user.uid else {
                return
            }
            let values = ["uid": uid, "firstName": firstName, "lastName": lastName, "email": email]
            self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
            self.transitionToHomeScreen()
        }
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]){
        let db = Database.database().reference(fromURL: "https://pet-records.firebaseio.com")
        let usersReference = db.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, db) in
            if err != nil {
                print(err!)
                return
            }
        })
    }
    
    func transitionToHomeScreen(){
        let vc = TabBarViewController()
        _ = self.navigationController?.pushViewController(vc, animated: false)
        self.navigationController?.viewControllers = [vc]
    }
    
    func uiSetup(){
        view.addSubview(backgroundImageView)
        view.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(firstNameTextField)
        mainStackView.addArrangedSubview(lastNameTextField)
        mainStackView.addArrangedSubview(emailTextField)
        mainStackView.addArrangedSubview(passwordTextField)
        mainStackView.addArrangedSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(submitButton)
        
        addToolBar(textField: firstNameTextField)
        addToolBar(textField: lastNameTextField)
        addToolBar(textField: emailTextField)
        addToolBar(textField: passwordTextField)
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.9).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: view.frame.size.width * 0.9).isActive = true
        backgroundImageView.image = UIImage(named: "PawPrints")
        
        mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mainStackView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9).isActive = true
        mainStackView.distribution = .fillEqually
        mainStackView.alignment = .fill
        mainStackView.axis = .vertical
        mainStackView.spacing = 2
        
        buttonStackView.distribution = .fillEqually
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 6
        
        firstNameTextField.backgroundColor = .white
        firstNameTextField.autocorrectionType = .no
        firstNameTextField.layer.borderWidth = 1
        firstNameTextField.layer.borderColor = UIColor.black.cgColor
        firstNameTextField.placeholder = "First Name"
        
        lastNameTextField.autocorrectionType = .no
        lastNameTextField.backgroundColor = .white
        lastNameTextField.layer.borderWidth = 1
        lastNameTextField.layer.borderColor = UIColor.black.cgColor
        lastNameTextField.placeholder = "Last Name"
        
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        emailTextField.backgroundColor = .white
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.black.cgColor
        emailTextField.placeholder = "Email"
        
        passwordTextField.backgroundColor = .white
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.black.cgColor
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
        passwordTextField.placeholder = "Password"
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.backgroundColor = .systemRed
        cancelButton.setTitle("Cancel", for: .normal)
        
        submitButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        submitButton.backgroundColor = .systemGreen
        submitButton.setTitle("Submit", for: .normal)
    }
    
    
    
    @objc func cancelButtonTapped(_ sender: Any){
        _ = navigationController?.popViewController(animated: true)
    }
}
