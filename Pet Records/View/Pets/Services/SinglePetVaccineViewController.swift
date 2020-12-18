//
//  SinglePetVaccineViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 5/17/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class SinglePetVaccineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let vaccineTableView = UITableView()
    var vaccines = [Vaccine?]()
    var pet : Pet?
    let cellid = "cellid"
    
    func loadPetDetails(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("user_vaccines").child(uid!).observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]   {
                if snapshot.childSnapshot(forPath: "pet_id").value as! String == (self.pet?.pid)! {
                    let dict = Vaccine(dictionary : dictionary)
                    self.vaccines.append(dict)
                    DispatchQueue.main.async(execute: {
                        self.vaccineTableView.reloadData()
                    })
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vaccineTableView.register(VacineTableViewCell.self, forCellReuseIdentifier: cellid)
        loadPetDetails()
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(vaccineTableView)
        vaccineTableView.translatesAutoresizingMaskIntoConstraints = false
        vaccineTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vaccineTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        vaccineTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        vaccineTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        vaccineTableView.separatorInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        vaccineTableView.delegate = self
        vaccineTableView.dataSource = self
    }
    
    //MARK: - TABLEVIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vaccines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! VacineTableViewCell
        cell.titleLabel.textColor = .black
        cell.startDateLabel.textColor = Colors.darkPurple
        cell.titleLabel.text = vaccines[indexPath.row]?.title
        cell.startDateLabel.text = vaccines[indexPath.row]?.startDate
        cell.endDateLabel.text = vaccines[indexPath.row]?.endDate
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 3
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
