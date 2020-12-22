//
//  HomeScreenViewController.swift
//  Pet Records

//  Created by Aaron Fulwider on 3/26/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class HomeScreenViewController: UIViewController, UITableViewDelegate {
    
    var petArray = [Pet?]()
    let backgroundImageView = UIImageView()
    let bottomView = UIView()
    let addPetTextField = UITextField()
    let cellID = "cellID"
    let petCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    var abbrevArray = [String?]()
    
    func fetchUserPets() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).child("pets").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]   {
                let pet = Pet(dictionary : dictionary)
                self.petArray.append(pet)
                DispatchQueue.main.async(execute: {
                    self.petCollectionView.reloadData()
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "home"
        topUI()
        bottomUI()
        fetchUserPets()
    }
    
    func topUI(){
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.image = UIImage(named: "PawPrints")
        collectionViewUI()
    }
    
    func bottomUI() {
        let toolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(CancelNameEnter_KeyboardDown))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let submit  = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(submitButtonTapped))
        let items = [cancel, flexSpace, submit]
        toolBar.items = items
        toolBar.sizeToFit()
        
        view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.topAnchor.constraint(equalTo: petCollectionView.bottomAnchor).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        bottomView.addSubview(addPetTextField)
        addPetTextField.translatesAutoresizingMaskIntoConstraints = false
        addPetTextField.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 4).isActive = true
        addPetTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addPetTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        addPetTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addPetTextField.backgroundColor = .white
        addPetTextField.contentMode = .right
        addPetTextField.layer.cornerRadius = 8
        addPetTextField.layer.borderWidth = 2
        addPetTextField.layer.borderColor = UIColor.black.cgColor
        addPetTextField.placeholder = "Add your new pet's name here!"
        addPetTextField.textAlignment = .center
        addPetTextField.inputAccessoryView = toolBar
    }
    
    @objc func submitButtonTapped() {
        let alert = UIAlertController(title: "", message: "Register \(addPetTextField.text!)?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.registerPet() }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.cancelRegisterPet() }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func registerPet() {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(uid!).child("pets")
        let childRef = ref.childByAutoId()
        let values = ["pid": childRef.key!,"name": addPetTextField.text!]
        DispatchQueue.main.async(execute: {
            childRef.updateChildValues(values)
        })
        addPetTextField.text = ""
    }
    
    @objc func cancelRegisterPet() {
        
    }
    
    @objc func CancelNameEnter_KeyboardDown() {
        addPetTextField.resignFirstResponder()
    }
    
    // MARK: - LOGOUT
    @objc func signOutTapped(){
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let vc = WelcomeViewController()
        let navigationController = self.navigationController
        navigationController?.setViewControllers([vc], animated:false)
    }
}

extension HomeScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionViewUI() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: view.frame.width/6, height: view.frame.width/6)
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 4, bottom: 10, right: 4)
        
        view.addSubview(petCollectionView)
        petCollectionView.delegate = self
        petCollectionView.dataSource = self
        petCollectionView.register(petCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        petCollectionView.collectionViewLayout = flowLayout
        petCollectionView.translatesAutoresizingMaskIntoConstraints = false
        petCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        petCollectionView.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        petCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        petCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        petCollectionView.backgroundColor = .clear
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! petCollectionViewCell
        let row = indexPath.row
        let name = petArray[row]?.name
        cell.abbLabel.text = name!.prefix(1).uppercased()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let pet = petArray[indexPath.row] {
            let vc = PetDetailsViewController()
            vc.pet = pet
            _ = navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK:- CELL CLASS
class petCollectionViewCell : UICollectionViewCell {
    let petImageView = UIImageView()
    let abbLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        cellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellUI() {
        contentView.layer.cornerRadius = 6.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .white
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        layer.backgroundColor = UIColor.clear.cgColor
        
        addSubview(abbLabel)
        abbLabel.translatesAutoresizingMaskIntoConstraints = false
        abbLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        abbLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        abbLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        abbLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        abbLabel.textColor = Colors.darkBrown
        abbLabel.adjustsFontSizeToFitWidth = true
        abbLabel.textAlignment = .center
        abbLabel.font = UIFont(name:"Chalkboard SE", size: 50)
    }
}
