//
//  AppointmentsViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/11/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class SinglePetAppointmentsViewController: UITableViewController {
    
    var appointment = [Appointment?]()
    var pet : Pet?
    let cellid = "cellid"
    
    func loadPetDetails(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child(uid!).child("pets").child(pet!.pid!).child("appointments").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]   {
                if snapshot.childSnapshot(forPath: "pet_id").value as! String == (self.pet?.pid)! {
                    let dict = Appointment(dictionary : dictionary)
                    self.appointment.append(dict)
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addAppointmentButtonTapped))
        tableView.register(VacineTableViewCell.self, forCellReuseIdentifier: cellid)
        loadPetDetails()
    }
    
    @objc func addAppointmentButtonTapped() {
        // Add alert view here
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointment.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! AppointmentsTableViewCell
        cell.titleLabel.text = appointment[indexPath.row]?.title
        cell.descriptionLabel.text = appointment[indexPath.row]?.descriptionString
        cell.timeLabel.text = appointment[indexPath.row]?.time
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
