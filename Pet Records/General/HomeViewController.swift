//
//  HomeViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 6/18/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase
import SideMenu

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var pets = [PetNSObject?]()
    let cellID = "cell"
    
    let petCollectionView = UICollectionView()
    
    var menu : SideMenuNavigationController?
    
    func fetchPets() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("user_pets").child(uid!).observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]   {
                let pet = PetNSObject(dictionary : dictionary)
                self.pets.append(pet)
                DispatchQueue.main.async(execute: {
                    self.petCollectionView.reloadData()
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu = SideMenuNavigationController(rootViewController: UIViewController())
        menu?.leftSide = true
        
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
        navigationItem.title = "Your Pets"
        petCollectionView.register(PetsTableViewCell.self, forCellWithReuseIdentifier: cellID)
        fetchPets()
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(backButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(didTapMenu))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addPetTapped))
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.setGradientBackground(Colors.lightBlue.cgColor, Colors.mediumBlue.cgColor, CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0))
    }
    
    @objc func didTapMenu() {
        present(menu!, animated: true)
    }
    
    func setupUI() {
        view.addSubview(petCollectionView)
        petCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        petCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        petCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        petCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        petCollectionView.allowsSelection = true
        petCollectionView.delegate = self
        
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? MainPetTableViewCell else {
            return UICollectionViewCell()
        }
        cell.nameLabel.text = pets[indexPath.row]?.name
        if let petImageURL = pets[indexPath.row]?.profileImageURL {
            cell.petImage.loadImageUsingCacheWithUrlString(petImageURL)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PetDetailsViewController()
        let pet = self.pets[indexPath.row]
        vc.pet = pet
        _ = navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addPetTapped(){
        let vc = AddPetViewController()
        _ = navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func backButton(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func signOutTapped(){
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

class MainPetTableViewCell : UICollectionViewCell {
    
    let petImage        = UIImageView()
    let nameLabel       = UILabel()
    let topSeparator    = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        uiSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func uiSetup(){
        addSubview(petImage)
        addSubview(nameLabel)
        
        petImage.translatesAutoresizingMaskIntoConstraints  = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        petImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        petImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        petImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        petImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        petImage.layer.cornerRadius = 20
        petImage.clipsToBounds = true
        
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: petImage.trailingAnchor, constant: 10).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nameLabel.adjustsFontSizeToFitWidth = true
        
        layer.masksToBounds = false
        layer.cornerRadius = 2.0
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowOpacity = 0.2
    }
}
