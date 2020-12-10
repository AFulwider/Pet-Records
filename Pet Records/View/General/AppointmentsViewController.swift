//
//  AppointmentsViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/11/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class SinglePetAppointmentViewController: UITableViewController {
    
    var appointments = [AppointmentNSObject?]()
    let cellid = "cellid"
    
    func loadPetDetails(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("user_appointments").child(uid!).observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]   {
                let dict = AppointmentNSObject(dictionary : dictionary)
                self.appointments.append(dict)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPetDetails()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addAppointmentTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(backButton))
        tableView.register(AppointmentsTableViewCell.self, forCellReuseIdentifier: cellid)
        view.backgroundColor = Colors.lightBrown
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! AppointmentsTableViewCell
        let appointment = appointments[indexPath.row]
        cell.title.text = appointment?.title
        cell.petName.text = appointment?.petName
        cell.time.text = appointment?.time
        return cell
    }
    
    @objc func addAppointmentTapped(){
        let vc = AddAppointmentViewController()
        _ = navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func backButton(){
        navigationController?.popViewController(animated: true)
    }
}

class AppointmentsTableViewCell: UITableViewCell {
    let title    = UILabel()
    let petName   = UILabel()
    let time   = UILabel()
    
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
        addSubview(title)
        addSubview(petName)
        addSubview(time)
        title.translatesAutoresizingMaskIntoConstraints  = false
        petName.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints  = false
        
        title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        title.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        title.widthAnchor.constraint(equalToConstant: (frame.width/2)).isActive = true
        title.adjustsFontSizeToFitWidth = true
        
        petName.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 2).isActive = true
        petName.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        petName.widthAnchor.constraint(equalToConstant: (frame.width/4)).isActive = true
        petName.adjustsFontSizeToFitWidth = true
        
        time.leadingAnchor.constraint(equalTo: petName.trailingAnchor, constant: 2).isActive = true
        time.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        time.widthAnchor.constraint(equalToConstant: (frame.width/4)).isActive = true
        time.adjustsFontSizeToFitWidth = true
    }
}
