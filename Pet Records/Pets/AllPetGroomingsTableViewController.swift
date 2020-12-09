//
//  PetGroomingsViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/29/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class AllPetGroomingsTableViewController: UITableViewController {
    
    var grooms = [Groom?]()
    let groomCellId = "groomCell"
    var pet : Pet?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        grooms.removeAll()
        loadPetDetails()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addGroomingTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(backButton))
        tableView.register(GroomingTableviewCell.self, forCellReuseIdentifier: groomCellId)
        title = "Grooming"
        view.backgroundColor = .white
    }
    
    func loadPetDetails(){
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("user_grooming").child(uid).observe(.childAdded) { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]   {
                    let groom = Groom(dictionary : dictionary)
                    self.grooms.append(groom)
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }
            }
        }
    }
    
    @objc func backButton(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addGroomingTapped(){
        let vc = AddGroomingViewController()
        _ = navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - TABLEVIEWS
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: groomCellId, for: indexPath) as! GroomingTableviewCell
        let groom = grooms[indexPath.row]
        cell.title.text = groom?.title
        cell.date.text = groom?.groomDate
        return cell
    }
    
    @objc func groomingButtonTapped(){
        let vc = AddGroomingViewController()
        _ = navigationController?.pushViewController(vc, animated: true)
    }
}

class GroomingTableviewCell: UITableViewCell {
    
    let title = UILabel()
    let date = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        uiSetup()
    }
    
    func uiSetup(){
        addSubview(title)
        addSubview(date)
        
        title.translatesAutoresizingMaskIntoConstraints  = false
        date.translatesAutoresizingMaskIntoConstraints = false
        
        title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        title.widthAnchor.constraint(equalToConstant: (frame.width/2) - 4).isActive = true
        title.textAlignment = .left
        title.textColor = .black
        title.baselineAdjustment = .alignCenters
        title.adjustsFontSizeToFitWidth = true
        
        date.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2).isActive = true
        date.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        date.widthAnchor.constraint(equalToConstant: (frame.width/2) - 4).isActive = true
        date.textAlignment = .right
        date.textColor = .black
        date.adjustsFontSizeToFitWidth = true
        date.baselineAdjustment = .alignCenters
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
