//
//  ContactsViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/11/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class ContactsTableViewController: UITableViewController {
    
    var user = [User]()
    let contactsCellId = "CellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.mediumBlue
        navigationItem.title = "Connections"
        tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: contactsCellId)
        fetchUser()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(backButton))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        view.setGradientBackground(Colors.lightBlue.cgColor, Colors.mediumBlue.cgColor, CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0))
    }
    
    @objc func backButton(){
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - FETCHUSER()
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            print("1")
            if let dictionary = snapshot.value as? [String: AnyObject] {
                print("2")
                let user = User(dictionary: dictionary)
                self.user.append(user)
                DispatchQueue.main.async(execute: {
                    print("3")
                    self.tableView.reloadData()
                })
            }
        }, withCancel: nil)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: contactsCellId, for: indexPath) as! ContactsTableViewCell
        let current = user[indexPath.row]
        cell.name.text = ("\(String(describing: current.firstName!)) \(String(describing: current.lastName!))")
        cell.email.text = current.email!
        //        cell.profileImage.image = UIImage(named: "blank_profile_image")
        //        print("current profile picture: \(String(describing: current.profileImageURL))")
        
        if let profileImageURL = current.profileImageURL {
            cell.profileImage.loadImageUsingCacheWithUrlString(profileImageURL)
        }
        //        cell.backgroundColor = .clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = self.user[indexPath.row]
            self.toContactProfileViewController(user)
        }
    }
    
    func toContactProfileViewController(_ user: User){
        let vc = ContactProfileViewController()
        vc.user = user
        print("CONTACTS VC USER ID: \(String(describing: user.id))")
        _ = navigationController?.pushViewController(vc, animated: true)
    }
}

class ContactsTableViewCell: UITableViewCell {
    var profileImage = UIImageView()
    let name = UILabel()
    let email = UILabel()
    
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
        addSubview(profileImage)
        addSubview(name)
        addSubview(email)
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        name.translatesAutoresizingMaskIntoConstraints = false
        email.translatesAutoresizingMaskIntoConstraints = false
        
        profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profileImage.layer.cornerRadius = 30
        profileImage.clipsToBounds = true
        
        name.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        name.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15).isActive = true
        name.widthAnchor.constraint(equalToConstant: 300).isActive = true
        name.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        email.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5).isActive = true
        email.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15).isActive = true
        email.widthAnchor.constraint(equalToConstant: 300).isActive = true
        email.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
}
