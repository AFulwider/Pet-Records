//
//  InjuriesTableViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 12/20/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class InjuriesTableViewController: UITableViewController {
    
    var injuries = [Injury?]()
    let cellId = "cellID"
    var pet : Pet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addGroomButtonTapped))
        tableView.register(GroomingTableviewCell.self, forCellReuseIdentifier: cellId)
        loadPetDetails()
    }
    
    @objc func addGroomButtonTapped() {
        // Add alert view here
    }
    
    func loadPetDetails(){
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child(uid).child("pets").child(pet!.pid!).child("injuries").observe(.childAdded) { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]   {
                    let groom = Injury(dict : dictionary)
                    self.injuries.append(groom)
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return injuries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! InjuryTableviewCell
        let injury = injuries[indexPath.row]
        cell.titleLabel.text = injury?.title
        cell.descriptionLabel.text = injury?.descriptionString
        return cell
    }
}

class InjuryTableviewCell:UITableViewCell {
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        uiSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func uiSetup(){
        addSubview(titleLabel)
        addSubview(descriptionLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints  = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: (frame.width/2)).isActive = true
        titleLabel.adjustsFontSizeToFitWidth = true
        
        descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 2).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        descriptionLabel.widthAnchor.constraint(equalToConstant: (frame.width/4)).isActive = true
        descriptionLabel.adjustsFontSizeToFitWidth = true
    }
}
