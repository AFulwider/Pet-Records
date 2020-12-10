//
//  WelcomeViewController.swift
//  Pet Records

//  Created by Aaron Fulwider on 1/30/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

/*
 Have image slowly fade in after screen loads
 */
import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    let stackView = UIStackView()
    let signUpButton = SignInButtonCustom()
    let logInButton = SignInButtonCustom()
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if Auth.auth().currentUser != nil {
            let vc = HomeScreenViewController()
            DispatchQueue.main.async {
                _ = self.navigationController?.pushViewController(vc, animated: false)
                self.navigationController?.viewControllers = [vc]
            }
            
        } else {
            print("no user currently logged in")
        }
        viewLayout()
        navigationController?.navigationBar.barTintColor = Colors.darkBlue
    }
    
    func viewLayout(){
        view.addSubview(backgroundImageView)
        view.addSubview(stackView)
        stackView.addArrangedSubview(signUpButton)
        stackView.addArrangedSubview(logInButton)
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.image = UIImage(named: "PawPrints")
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        stackView.spacing = 4
        
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        signUpButton.setTitle("Sign up", for: .normal)
        
        logInButton.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)
        logInButton.setTitle("Log in", for: .normal)
    }
    
    @objc func signUpButtonTapped(_ sender: Any){
        let vc = SignUpViewController()
        _ = navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func logInButtonTapped(_ sender: Any){
        let vc = LogInViewController()
        _ = navigationController?.pushViewController(vc, animated: true)
    }
}
