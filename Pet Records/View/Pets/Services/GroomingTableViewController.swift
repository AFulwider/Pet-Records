//
//  SinglePetTableViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 5/17/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import CloudKit

class GroomingTableViewController: UITableViewController {
    
    var grooms = [Groom?]()
    let cellId = "cellID"
    var pet : Pet?
    
    var titleTextFieldFunc : UITextField?
    var descriptionTextFieldFunc : UITextField?
    var dateTextFieldFunc : UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addGroomButtonTapped))
        tableView.register(GroomingTableviewCell.self, forCellReuseIdentifier: cellId)
        loadPetDetails()
    }
    
    func loadPetDetails(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).child("pets").child(pet!.pid!).child("grooming").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]   {
                let dict = Groom(dictionary : dictionary)
                self.grooms.append(dict)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    @objc func addGroomButtonTapped() {
        let alert = UIAlertController(title: "Enter the details of your grooming", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: titleTextFieldFunc)
        alert.addTextField(configurationHandler: descriptionTextFieldFunc)
        alert.addTextField(configurationHandler: dateTextFieldFunc)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: self.saveGroomingButtonTapped) )
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
    
    func dateTextFieldFunc(textField:UITextField!) {
        dateTextFieldFunc = textField
        dateTextFieldFunc?.placeholder = DateHelper.shared.todaysDate()
    }
    
    func saveGroomingButtonTapped(alert: UIAlertAction) {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(uid).child("pets").child(pet!.pid!).child("grooming")
            let childRef = ref.childByAutoId()
            let values = ["title": titleTextFieldFunc!.text!,"description": descriptionTextFieldFunc!.text!,"time": dateTextFieldFunc!.text!, "id":childRef.key!] as [AnyHashable : Any]
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
        return grooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! GroomingTableviewCell
        let groom = grooms[indexPath.row]
        cell.titleLabel.text = groom?.title
        cell.descriptionLabel.text = groom?.descriptionString
        cell.timeLabel.text = groom?.time
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let uid = Auth.auth().currentUser?.uid
            let ref = Database.database().reference().child("users").child(uid!).child("pets").child((pet?.pid)!).child("grooming").child((grooms[indexPath.row]?.id!)!)
            ref.removeValue()
            grooms.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}
