//
//  HomeScreenTableViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/6/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class PetsTableViewController: UITableViewController {
    
    var pets = [PetNSObject?]()
    let petCellId = "petCell"
    
    func fetchUserPets() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("user_pets").child(uid!).observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]   {
                let pet = PetNSObject(dictionary : dictionary)
                self.pets.append(pet)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Your Pets"
        tableView.register(PetsTableViewCell.self, forCellReuseIdentifier: petCellId)
        fetchUserPets()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(backButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addPetTapped))
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.setGradientBackground(Colors.lightBlue.cgColor, Colors.mediumBlue.cgColor, CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0))
    }
    
    @objc func addPetTapped(){
        let vc = AddPetViewController()
        _ = navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func backButton(){
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: petCellId, for: indexPath) as! PetsTableViewCell
        cell.nameLabel.text = pets[indexPath.row]?.name
        if let petImageURL = pets[indexPath.row]?.profileImageURL {
            cell.petImage.loadImageUsingCacheWithUrlString(petImageURL)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PetDetailsViewController()
        let pet = self.pets[indexPath.row]
        vc.pet = pet
        _ = navigationController?.pushViewController(vc, animated: true)
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

class PetsTableViewCell : UITableViewCell {
    
    let petImage    = UIImageView()
    let nameLabel   = UILabel()
    let topSeparator = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        uiSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
