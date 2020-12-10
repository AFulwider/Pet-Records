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
        self.navigationItem.setHidesBackButton(true, animated: true)
        view.backgroundColor = Colors.lightPurple
        viewLayout()
        title = "LogInViewController"
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
        
        vertStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        vertStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        vertStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        vertStackView.distribution = .fillEqually
        vertStackView.axis = .vertical
        vertStackView.spacing = 4
        
        horStackView.distribution = .fillEqually
        horStackView.axis = .horizontal
        horStackView.spacing = 4
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.backgroundColor = Colors.darkPurple
        cancelButton.setTitle("Cancel", for: .normal)
        
        submitButton.addTarget(self, action: #selector(logInTapped), for: .touchUpInside)
        submitButton.backgroundColor = Colors.lightGreen
        submitButton.setTitle("Submit", for: .normal)
        
        
        errorLabel.bottomAnchor.constraint(equalTo: vertStackView.topAnchor, constant: -10).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: vertStackView.leadingAnchor).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: vertStackView.trailingAnchor).isActive = true
        errorLabel.numberOfLines = 0
        errorLabel.alpha = 0
        
        emailTextField.delegate = self
        emailTextField.backgroundColor = .white
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.black.cgColor
        
        passwordTextField.delegate = self
        passwordTextField.backgroundColor = .white
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.black.cgColor
    }
    
    @objc func logInTapped() {
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
