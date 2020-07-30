//
//  MessagesTableViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/16/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class SendMessagesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    let messagesCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    let separatorLine = UIView() // Line between containerView and messagesCollectionView
    let containerView = UIView() // Container to hold messaging input ui
    lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 25
        textField.textColor = .white
        textField.placeholder = "Enter message..."
        textField.delegate = self
        return textField
    }()
    
    
    let sendButton = UIButton(type: .system)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMessageInputComponents()
        view.backgroundColor = .black
    }
    
    func setupMessageInputComponents(){
        let containerHeight = CGFloat(50)
        view.addSubview(containerView)
        view.addSubview(separatorLine)
        containerView.addSubview(sendButton)
        containerView.addSubview(inputTextField)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: containerHeight).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        separatorLine.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        separatorLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        separatorLine.backgroundColor = .white
        
        inputTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.9).isActive = true
        
        sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        sendButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendButtonAction()
        return true
    }
    @objc func sendButtonAction(){
        let ref = Firebase.Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let values = ["text":inputTextField.text!]
        childRef.updateChildValues(values)
        print(inputTextField.text!)
    }
    
    func collectionViewSetup(){
        messagesCollectionView.delegate = self
        messagesCollectionView.dataSource = self
        view.addSubview(messagesCollectionView)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        messagesCollectionView.showsHorizontalScrollIndicator = false
        messagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        messagesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        messagesCollectionView.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        messagesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messagesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        messagesCollectionView.frame = .zero
        messagesCollectionView.collectionViewLayout = layout
        messagesCollectionView.register(MessagesCollectionViewCell.self, forCellWithReuseIdentifier: "MessagesCell")
    }
    
    //MARK: - MESSAGES COLLECTIONVIEW
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:(collectionView.frame.width)/2, height: (collectionView.frame.height) - 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessagesCell", for: indexPath) as? MessagesCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // PULLED FROM OTHER PET RECORDS PROJECT FOR EXAMPLES
        
        //                let pet = pets[indexPath.row]
        //
        //                let fileManager = FileManager.default
        //                let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        //                let filePath = documentsURL.appendingPathComponent(pet.profilePicPath!)
        //                if fileManager.fileExists(atPath: filePath.path) {
        //                    let contentsOfFilePath = UIImage(contentsOfFile: filePath.path)
        //                        cell.petImage.image = contentsOfFilePath
        //                }
        //
        //                cell.nameLabel.text = pet.name!
        //                cell.breedLabel.text = pet.breed!
        //                cell.ageLabel.text = DateAssist.currentAgeForDate(pet.dateOfBirth!)
        //        //        pet.isDog ? (cell.isDogLabel.text = "DOG") : (cell.isDogLabel.text = "CAT")
        //        //        pet.isBoy ? (cell.isBoyLabel.text = "BOY") : (cell.isBoyLabel.text = "GIRL")
        //                cell.hasAppointment.text = "Appointment Soon"
        return cell
    }
}

class MessagesCollectionViewCell: UICollectionViewCell {
    
}
