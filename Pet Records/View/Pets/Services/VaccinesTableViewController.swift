//
//  SinglePetVaccineViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 5/17/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import CloudKit

class VaccinesTableViewController: UITableViewController {
    
    var vaccines = [Vaccine?]()
    var pet : Pet?
    let cellid = "cellid"
    
    var titleTextFieldFunc : UITextField?
    var dateTextFieldFunc : UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addVaccineButtonTapped))
        tableView.register(VaccineTableViewCell.self, forCellReuseIdentifier: cellid)
        loadPetDetails()
    }
    
    func loadPetDetails(){
        let uid = (Auth.auth().currentUser?.uid)!
        Database.database().reference().child("users").child(uid).child("pets").child(pet!.pid!).child("vaccines").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]   {
                let dict = Vaccine(dictionary : dictionary)
                self.vaccines.append(dict)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    @objc func addVaccineButtonTapped() {
        let alert = UIAlertController(title: "Enter the details of the vaccine", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: titleTextFieldFunc)
        alert.addTextField(configurationHandler: dateTextFieldFunc)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: self.saveVaccineButtonTapped) )
        present(alert, animated: true, completion: nil)
    }
    
    func titleTextFieldFunc(textField:UITextField!) {
        titleTextFieldFunc = textField
        titleTextFieldFunc?.placeholder = "Name of Vaccine"
    }
    
    func dateTextFieldFunc(textField:UITextField!) {
        dateTextFieldFunc = textField
        dateTextFieldFunc?.placeholder = DateHelper.shared.todaysDate()
    }
    
    func saveVaccineButtonTapped(alert: UIAlertAction) {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(uid).child("pets").child(pet!.pid!).child("vaccines")
            let childRef = ref.childByAutoId()
            let values = ["title": titleTextFieldFunc!.text!,"date": dateTextFieldFunc!.text!, "id":childRef.key!] as [AnyHashable : Any]
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
        return vaccines.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! VaccineTableViewCell
        cell.titleLabel.text = vaccines[indexPath.row]?.title
        cell.timeLabel.text = vaccines[indexPath.row]?.vacDate
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let uid = Auth.auth().currentUser?.uid
            let ref = Database.database().reference().child("users").child(uid!).child("pets").child((pet?.pid)!).child("vaccines").child((vaccines[indexPath.row]?.id!)!)
            ref.removeValue()
            vaccines.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}
