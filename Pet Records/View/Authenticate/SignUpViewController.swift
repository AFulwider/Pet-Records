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
import Firebase

class SignUpViewController: UIViewController, UINavigationControllerDelegate {
    
    var homeScreenController = HomeScreenViewController()
    
    let mainStackView = UIStackView()
    let buttonStackView = UIStackView()
    
    let profileImageView   = UIImageView()
    let firstNameTextField = UITextField()
    let lastNameTextField  = UITextField()
    let emailTextField     = UITextField()
    let passwordTextField  = UITextField()
    
    let errorLabel         = UILabel()
    
    let submitButton       = SignInButtonCustom()
    let cancelButton       = SignInButtonCustom()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = .white
//        view.setGradientBackground(Colors.lightBlue.cgColor, Colors.mediumBlue.cgColor, CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0))
    }
    
    var vacViewHeight : NSLayoutConstraint?
    var firstNameHeight : NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetup()
        self.navigationItem.setHidesBackButton(true, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 0//keyboardFrame.height
            print("self.view.frame.origin.y: \(self.view.frame.origin.y)")
            print("keyboardFrame: \(keyboardFrame.height)")
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func validateFields() -> String? {
        if firstNameTextField   .text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField   .text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField      .text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField   .text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        // Check if password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        return nil
    }
    
    //TODO: - STILL TRYING TO FIGURE OUT FIRESTORE()
    @objc func signUpTapped() {
        let error = validateFields()
        if let error = error {
            print(error)
        } else {
            // Create cleaned versions of data
            let firstName   = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName    = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email       = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password    = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Authenticate
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in // Create User
                if let error = error {
                    self.showErrorMessage("Error creating user in authenticator") // Error message label
                    print(error)
                } else {
                    // Real-time database
                    guard let uid = result?.user.uid else {
                        return
                    }
                    let imageName = NSUUID().uuidString
                    let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
                    if let uploadData = self.profileImageView.image!.pngData() {
                        storageRef.putData(uploadData, metadata: nil, completion:  { (metadata, error) in
                            if (error != nil) {
                                return
                            }
                            storageRef.downloadURL { (url, error) in
                                if let profileImageURL = url?.absoluteString  {
                                    let values = ["uid": uid, "firstName": firstName, "lastName": lastName, "email": email, "profileImage": profileImageURL]
                                    self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                                    return
                                }
                            }
                        })
                    }
                    self.transitionToHomeScreen()
                }
            }
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
            self.homeScreenController.fetchUserAndSetupNavBarTitle()
        })
    }
    
    func showErrorMessage(_ message:String){
        errorLabel.text     = message
        errorLabel.alpha    = 1
    }
    
    func transitionToHomeScreen(){
        let vc = HomeScreenViewController()
        let navigationController = self.navigationController
        navigationController?.setViewControllers([vc], animated:false)
    }
    
    func uiSetup(){
//        view.addSubview(backgroundImageView)
        view.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(firstNameTextField)
        mainStackView.addArrangedSubview(lastNameTextField)
        mainStackView.addArrangedSubview(emailTextField)
        mainStackView.addArrangedSubview(passwordTextField)
        mainStackView.addArrangedSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(submitButton)
        
        view.addSubview(profileImageView)
        view.addSubview(errorLabel)
        
        addToolBar(textField: firstNameTextField)
        addToolBar(textField: lastNameTextField)
        addToolBar(textField: emailTextField)
        addToolBar(textField: passwordTextField)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints         = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints       = false
        profileImageView.translatesAutoresizingMaskIntoConstraints      = false
        firstNameTextField.translatesAutoresizingMaskIntoConstraints    = false
        lastNameTextField.translatesAutoresizingMaskIntoConstraints     = false
        emailTextField.translatesAutoresizingMaskIntoConstraints        = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints     = false
        errorLabel.translatesAutoresizingMaskIntoConstraints            = false
        submitButton.translatesAutoresizingMaskIntoConstraints          = false
        cancelButton.translatesAutoresizingMaskIntoConstraints          = false
//        backgroundImageView.translatesAutoresizingMaskIntoConstraints   = false
        
//        backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        backgroundImageView.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.9).isActive = true
//        backgroundImageView.heightAnchor.constraint(equalToConstant: view.frame.size.width * 0.9).isActive = true
//        backgroundImageView.image = UIImage(named: "dog_cat_transparent")
        
        mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mainStackView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9).isActive = true
        mainStackView.distribution  = .fillEqually
        mainStackView.alignment     = .fill
        mainStackView.axis          = .vertical
        mainStackView.spacing       = 2
        
        buttonStackView.distribution  = .fillEqually
        buttonStackView.alignment     = .fill
        buttonStackView.axis          = .horizontal
        buttonStackView.spacing       = 6
        
        errorLabel.bottomAnchor.constraint(equalTo: mainStackView.topAnchor, constant: -10).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor).isActive = true
        errorLabel.numberOfLines = 0
        errorLabel.alpha = 0
        
        profileImageView.image = UIImage(named: "blank_profile_image")
        profileImageView.bottomAnchor.constraint(equalTo: mainStackView.topAnchor, constant: -20).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.contentMode = .scaleToFill
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageSelected)))
        profileImageView.isUserInteractionEnabled = true
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.backgroundColor = Colors.red
        cancelButton.setTitle("Cancel", for: .normal)
        
        submitButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        submitButton.backgroundColor = Colors.mediumGreen
        submitButton.setTitle("Submit", for: .normal)
        
    }
    
    
    @objc func cancelButtonTapped(_ sender: Any){
        _ = navigationController?.popViewController(animated: true)
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate {
    @objc func profileImageSelected(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            selectedImageFromPicker = editedImage
            //            print(editedImage)
        } else if let originalImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            selectedImageFromPicker = originalImage
            //            print(originalImage)
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Canceled Picker")
        dismiss(animated: true, completion: nil)
    }
}
