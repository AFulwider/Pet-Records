//
//  WelcomeViewController.swift
//  Pet Records

//  Created by Aaron Fulwider on 1/30/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    let signUpButton = SignInButtonCustom()
    let logInButton = SignInButtonCustom()
    let tempButton = SignInButtonCustom()
    let backgroundImageView = UIImageView()
    var count = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // if user is already logged in, go to home screen and that will then be the welcome screen each time user opens the app, until they log out.
        if Auth.auth().currentUser != nil {
            let vc = HomeScreenViewController()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = UINavigationController(rootViewController: HomeScreenViewController())
            _ = navigationController?.pushViewController(vc, animated: true)
        } else {
            print("no user currently logged in")
        }
        viewLayout()
        navigationController?.navigationBar.barTintColor = Colors.darkBlue
    }
    
    func viewLayout(){
        view.addSubview(backgroundImageView)
        view.addSubview(tempButton)
        view.addSubview(signUpButton)
        view.addSubview(logInButton)
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints  = false
        logInButton.translatesAutoresizingMaskIntoConstraints   = false
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.image = UIImage(named: "PawPrints")
        
        // bottom button
        signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100).isActive = true
        signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        signUpButton.setTitle("Sign up", for: .normal)
        
        // top button
        logInButton.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -20).isActive = true
        logInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        logInButton.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)
        logInButton.setTitle("Log in", for: .normal)
        
        // temp button
        tempButton.bottomAnchor.constraint(equalTo: logInButton.topAnchor, constant: -20).isActive = true
        tempButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        tempButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        tempButton.addTarget(self, action: #selector(tempButtonTapped), for: .touchUpInside)
        tempButton.setTitle("Temp Button", for: .normal)
    }
    
    @objc func tempButtonTapped(_ sender: Any) {
        if !count  {
        view.backgroundColor = Colors.darkPurple
            count = true
        } else {
            view.backgroundColor = Colors.lightBlue
            count = false
        }
    }
    
    @objc func signUpButtonTapped(_ sender: Any){
        let vc = SignUpViewController()
        _ = navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func logInButtonTapped(_ sender: Any){
        let vc = LogInViewController()
        _ = navigationController?.present(vc, animated: true)
//        _ = navigationController?.pushViewController(vc, animated: true)
    }
}
