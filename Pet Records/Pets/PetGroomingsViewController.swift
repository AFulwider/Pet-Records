//
//  PetGroomingsViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/29/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class PetGroomingsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var petGrooms = [GroomingNSObject?]()
    let groomingTableView = UITableView()
    let groomCellId = "groomCell"
    
    var pet : PetNSObject?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPetDetails()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groomingTableView.register(GroomingTableviewCell.self, forCellReuseIdentifier: groomCellId)
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(groomingTableView)
        groomingTableView.translatesAutoresizingMaskIntoConstraints = false
        groomingTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        groomingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        groomingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        groomingTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        groomingTableView.delegate = self
        groomingTableView.dataSource = self
    }
    
    func loadPetDetails(){
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("pet_grooming").child(uid).child((pet?.pid)!).observe(.childAdded) { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]   {
                    let dict = GroomingNSObject(dictionary : dictionary)
                    self.petGrooms.append(dict)
                    DispatchQueue.main.async(execute: {
                        self.groomingTableView.reloadData()
                    })
                }
            }
        }
    }
    
    //MARK: - TABLEVIEWS
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petGrooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: groomCellId, for: indexPath) as! GroomingTableviewCell
        let groom = petGrooms[indexPath.row]
        cell.title.text = groom?.title
        cell.date.text = groom?.groomDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // show list of grooming past and future
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func uiSetup(){
        addSubview(title)
        addSubview(date)
        
        title.translatesAutoresizingMaskIntoConstraints  = false
        date.translatesAutoresizingMaskIntoConstraints = false
        
        title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        title.heightAnchor.constraint(equalToConstant: 25).isActive = true
        title.widthAnchor.constraint(equalToConstant: (frame.width/2) - 4).isActive = true
        title.textAlignment = .left
        title.textColor = .black
        title.baselineAdjustment = .alignCenters
        title.adjustsFontSizeToFitWidth = true
        
        date.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2).isActive = true
        date.heightAnchor.constraint(equalToConstant: 25).isActive = true
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
