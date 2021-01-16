//
//  MedicationTableViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 12/20/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import CloudKit

class MedicationTableViewController: UITableViewController {
    
    var meds = [Medication?]()
    let cellId = "cellID"
    var pet : Pet?
    
    var titleTextFieldFunc : UITextField?
    var descriptionTextFieldFunc : UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addMedicationButtonTapped))
        tableView.register(MedicationTableViewCell.self, forCellReuseIdentifier: cellId)
        loadPetDetails()
    }
    
    func loadPetDetails(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).child("pets").child(pet!.pid!).child("medication").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]   {
                let dictionary = Medication(dictionary : dictionary)
                self.meds.append(dictionary)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    @objc func addMedicationButtonTapped() {
        let alert = UIAlertController(title: "Enter the details of the medication", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: titleTextFieldFunc)
        alert.addTextField(configurationHandler: descriptionTextFieldFunc)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: self.saveMedicationButtonTapped) )
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
    
    func saveMedicationButtonTapped(alert: UIAlertAction) {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(uid).child("pets").child(pet!.pid!).child("medication")
            let childRef = ref.childByAutoId()
            let values = ["title": titleTextFieldFunc!.text!,"description": descriptionTextFieldFunc!.text!, "id":childRef.key!] as [AnyHashable : Any]
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MedicationTableViewCell
        let med = meds[indexPath.row]
        cell.titleLabel.text = med?.title
        cell.descriptionLabel.text = med?.descriptionString
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let uid = Auth.auth().currentUser?.uid
            let ref = Database.database().reference().child("users").child(uid!).child("pets").child((pet?.pid)!).child("medication").child((meds[indexPath.row]?.id!)!)
            ref.removeValue()
            meds.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}
