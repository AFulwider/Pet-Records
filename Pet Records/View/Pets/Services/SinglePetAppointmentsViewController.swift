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
    
    var appointments = [Appointment?]()
    var pet : Pet?
    let cellid = "cellid"
    
    var titleTextFieldFunc : UITextField?
    var descriptionTextFieldFunc : UITextField?
    var dateTextFieldFunc : UITextField?
    var locationTextFieldFunc : UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addAppointmentButtonTapped))
        tableView.register(AppointmentsTableViewCell.self, forCellReuseIdentifier: cellid)
        loadPetDetails()
    }
    
    func loadPetDetails(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).child("pets").child(pet!.pid!).child("appointments").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]   {
                let dict = Appointment(dictionary : dictionary)
                self.appointments.append(dict)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    @objc func addAppointmentButtonTapped() {
        let alert = UIAlertController(title: "Enter the details of your appointment", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: titleTextFieldFunc)
        alert.addTextField(configurationHandler: descriptionTextFieldFunc)
        alert.addTextField(configurationHandler: dateTextFieldFunc)
        alert.addTextField(configurationHandler: locationTextFieldFunc)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: self.saveAppointmentButtonTapped) )
        present(alert, animated: true, completion: nil)
    }
    
    func titleTextFieldFunc(textField:UITextField!) {
        titleTextFieldFunc = textField
        titleTextFieldFunc?.placeholder = "Title"
    }
    
    func descriptionTextFieldFunc(textField:UITextField!) {
        descriptionTextFieldFunc = textField
        descriptionTextFieldFunc?.placeholder = "Description"
    }
    
    func locationTextFieldFunc(textField:UITextField!) {
        locationTextFieldFunc = textField
        locationTextFieldFunc?.placeholder = "Location"
    }
    
    func dateTextFieldFunc(textField:UITextField!) {
        dateTextFieldFunc = textField
        dateTextFieldFunc?.placeholder = DateHelper.shared.todaysDate()
    }
    
    func saveAppointmentButtonTapped(alert: UIAlertAction) {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(uid).child("pets").child(pet!.pid!).child("appointments")
            let childRef = ref.childByAutoId()
            let values = ["title": titleTextFieldFunc!.text!,"description": descriptionTextFieldFunc!.text!,"time": dateTextFieldFunc!.text!,"location": locationTextFieldFunc!.text!, "id":childRef.key!] as [AnyHashable : Any]
            DispatchQueue.main.async(execute: {
                childRef.updateChildValues(values)
                self.tableView.reloadData()
            })
        }
        print("SAVED")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! AppointmentsTableViewCell
        cell.titleLabel.text = appointments[indexPath.row]?.title
        cell.descriptionLabel.text = appointments[indexPath.row]?.descriptionString
        cell.timeLabel.text = appointments[indexPath.row]?.time
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let uid = Auth.auth().currentUser?.uid
            let ref = Database.database().reference().child("users").child(uid!).child("pets").child((pet?.pid)!).child("appointments").child((appointments[indexPath.row]?.id!)!)
            ref.removeValue()
            appointments.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}
