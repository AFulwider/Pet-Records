//
//  UserProfileViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/11/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController {
    
    var pets : [PetNSObject]?
    
    let userProfileImage = UIImageView()
    let userFirstNameLabel = UILabel()
    let userLastNameLabel = UILabel()
    
    let petProfileImage = UIImageView()
    let userPetName = UILabel()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkIfUserIsLoggedIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(backButton))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.setGradientBackground(Colors.lightBlue.cgColor, Colors.mediumBlue.cgColor, CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0))
    }
    
    @objc func backButton(){
        navigationController?.popViewController(animated: true)
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil{
            perform(#selector(signOut), with: nil, afterDelay: 0)
        } else {
            uiSetup()
        }
    }
    
    func uiSetup(){
        view.addSubview(userFirstNameLabel)
        userFirstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userFirstNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        userFirstNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        userFirstNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        userFirstNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loadUser()
    }
    
    func loadUser() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = UserNSObject(dictionary: dictionary)
                self.userFirstNameLabel.text = user.firstName
                self.userLastNameLabel.text = user.lastName
            }
        }, withCancel: nil)
    }
    // MARK: - LOGOUT
    @objc func signOut(){
        print("signOutTapped")
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let vc = WelcomeScreenViewController()
        let navigationController = self.navigationController
        navigationController?.setViewControllers([vc], animated:false)
    }
}
