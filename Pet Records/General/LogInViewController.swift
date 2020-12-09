//
//  LoginViewController.swift
//  Pet Records

//  Created by Aaron Fulwider on 1/30/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LogInViewController: UIViewController {
    
    var homeScreenController = HomeScreenViewController()
    let backgroundImageView = UIImageView()
    
    let mainStackView       = UIStackView()
    let buttonStackView     = UIStackView()
    
    let emailTextField      = UITextField()
    let passwordTextField   = UITextField()
    let errorLabel          = UILabel()
    
    let submitButton        = SignInButtonCustom()
    let cancelButton        = SignInButtonCustom()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        view.backgroundColor = Colors.lightPurple
        viewLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        view.setGradientBackground(Colors.lightBlue.cgColor, Colors.mediumBlue.cgColor, CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0))
    }
    
    func viewLayout(){
        view.addSubview(backgroundImageView)
        view.addSubview(mainStackView)
        view.addSubview(buttonStackView)
        mainStackView.addArrangedSubview(emailTextField)
        mainStackView.addArrangedSubview(passwordTextField)
        mainStackView.addArrangedSubview(buttonStackView)
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(submitButton)
        view.addSubview(errorLabel)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints         = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints       = false
        emailTextField.translatesAutoresizingMaskIntoConstraints        = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints     = false
        errorLabel.translatesAutoresizingMaskIntoConstraints            = false
        submitButton.translatesAutoresizingMaskIntoConstraints          = false
        cancelButton.translatesAutoresizingMaskIntoConstraints          = false
        backgroundImageView.translatesAutoresizingMaskIntoConstraints   = false
        
        addToolBar(textField: emailTextField)
        addToolBar(textField: passwordTextField)
        
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.image = UIImage(named: "PawPrints")
        
        mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mainStackView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9).isActive = true
        mainStackView.distribution  = .fillEqually
        mainStackView.alignment     = .fill
        mainStackView.axis          = .vertical
        mainStackView.spacing       = 2
        
        Utilities.errorTextFields(errorLabel) // ERROR LABEL
        Utilities.styleTextFields(textfield: emailTextField, placeholder:"email", secureTextEntry:false)
        Utilities.styleTextFields(textfield: passwordTextField, placeholder:"password", secureTextEntry:true)
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.backgroundColor = Colors.red
        cancelButton.setTitle("Cancel", for: .normal)
        
        submitButton.addTarget(self, action: #selector(logInTapped), for: .touchUpInside)
        submitButton.backgroundColor = Colors.mediumGreen
        submitButton.setTitle("Submit", for: .normal)
        
        buttonStackView.distribution  = .fillEqually
        buttonStackView.alignment     = .fill
        buttonStackView.axis          = .horizontal
        buttonStackView.spacing       = 6
        
        errorLabel.bottomAnchor.constraint(equalTo: mainStackView.topAnchor, constant: -10).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor).isActive = true
        errorLabel.numberOfLines = 0
        errorLabel.alpha = 0
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @objc func logInTapped() {
        //TODO:- Validate text fields
        //TODO:- Create cleaned version of the text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                // couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            } else {
                self.transitionToHomeScreen()
            }
        }
    }
    
    @objc func doneButtonTapped() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func transitionToHomeScreen(){
        let vc = HomeScreenViewController()
        let navigationController = self.navigationController
        navigationController?.setViewControllers([vc], animated:false)
    }
    
    @objc func cancelButtonTapped(_ sender: Any){
        _ = navigationController?.popViewController(animated: true)
    }
}
