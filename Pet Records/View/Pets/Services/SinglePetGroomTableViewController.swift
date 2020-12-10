//
//  SinglePetTableViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 5/17/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class SinglePetGroomTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let groomingTableView = UITableView()
    var grooms = [Groom?]()
    let cellId = "groomCell"
    var pet : Pet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Grooming"
        groomingTableView.register(GroomingTableviewCell.self, forCellReuseIdentifier: cellId)
        loadPetDetails()
        setupUI()
        view.backgroundColor = .white
    }
    
    func loadPetDetails(){
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("user_grooming").child(uid).observe(.childAdded) { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]   {
                    let groom = Groom(dictionary : dictionary)
                    self.grooms.append(groom)
                    DispatchQueue.main.async(execute: {
                        self.groomingTableView.reloadData()
                    })
                }
            }
        }
    }
    
    func setupUI() {
        view.addSubview(groomingTableView)
        groomingTableView.translatesAutoresizingMaskIntoConstraints = false
        groomingTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        groomingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        groomingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        groomingTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        groomingTableView.backgroundColor = .clear
        groomingTableView.separatorInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        groomingTableView.delegate = self
        groomingTableView.dataSource = self
    }
    
    //MARK: - TABLEVIEWS
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grooms.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! GroomingTableviewCell
        let groom = grooms[indexPath.row]
        cell.title.text = groom?.title
        cell.date.text = groom?.groomDate
        return cell
    }
}
