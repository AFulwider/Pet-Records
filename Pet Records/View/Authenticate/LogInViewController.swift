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
    
    let vertStackView = UIStackView()
    let horStackView = UIStackView()
    
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let errorLabel = UILabel()
    
    let submitButton = SignInButtonCustom()
    let cancelButton = SignInButtonCustom()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: true)
        viewLayout()
    }
    
    func viewLayout(){
        view.addSubview(backgroundImageView)
        view.addSubview(vertStackView)
        view.addSubview(horStackView)
        view.addSubview(errorLabel)
        
        vertStackView.addArrangedSubview(emailTextField)
        vertStackView.addArrangedSubview(passwordTextField)
        vertStackView.addArrangedSubview(horStackView)
        horStackView.addArrangedSubview(cancelButton)
        horStackView.addArrangedSubview(submitButton)
        
        vertStackView.translatesAutoresizingMaskIntoConstraints = false
        horStackView.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.image = UIImage(named: "PawPrints")
        backgroundImageView.backgroundColor = .white
        
        vertStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        vertStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        vertStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        vertStackView.distribution = .fillEqually
        vertStackView.axis = .vertical
        vertStackView.spacing = 4
        
        horStackView.distribution = .fillEqually
        horStackView.axis = .horizontal
        horStackView.spacing = 4
        
//        cancelButton.addTarget(self, action: #selector(CancelNameEnter_KeyboardDown), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.backgroundColor = .systemRed
        cancelButton.setTitle("Cancel", for: .normal)
        
        submitButton.addTarget(self, action: #selector(logInTapped), for: .touchUpInside)
        submitButton.backgroundColor = .systemGreen
        submitButton.setTitle("Submit", for: .normal)
        
        errorLabel.bottomAnchor.constraint(equalTo: vertStackView.topAnchor, constant: -10).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: vertStackView.leadingAnchor).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: vertStackView.trailingAnchor).isActive = true
        errorLabel.numberOfLines = 0
        errorLabel.textColor = .systemRed
        errorLabel.alpha = 0
        
        emailTextField.backgroundColor = .white
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.black.cgColor
        emailTextField.autocorrectionType = .no
        emailTextField.placeholder = "Email"

        passwordTextField.backgroundColor = .white
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.black.cgColor
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
        passwordTextField.placeholder = "Password"
    }
    
    @objc func logInTapped() {
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
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
        let vc = TabBarViewController()
        let navigationController = self.navigationController
        navigationController?.setViewControllers([vc], animated:false)
    }
    
    @objc func cancelButtonTapped(_ sender: Any){
        _ = navigationController?.popViewController(animated: true)
    }
}
