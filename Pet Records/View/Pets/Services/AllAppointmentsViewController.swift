//
//  PetAppointmentsViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/29/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import CloudKit

class AllAppointmentsViewController: UITableViewController {
    
    var appointments = [Appointment?]()
    let appointmentCellId = "appCell"
    var pet : Pet?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appointments.removeAll()
        loadPetDetails()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addAppointmentTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(backButton))
        tableView.register(AppointmentsTableViewCell.self, forCellReuseIdentifier: appointmentCellId)
    }
    
    func loadPetDetails(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("appointments").child(uid!).observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]   {
                let dict = Appointment(dictionary : dictionary)
                self.appointments.append(dict)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    @objc func addAppointmentTapped(){
        let vc = AddAppointmentViewController()
        _ = navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func backButton(){
        navigationController?.popViewController(animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: appointmentCellId, for: indexPath) as! AppointmentsTableViewCell
        cell.titleLabel.text = appointments[indexPath.row]?.title
        cell.descriptionLabel.text = appointments[indexPath.row]?.descriptionString
        cell.timeLabel.text = appointments[indexPath.row]?.time
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
