//
//  ActiveUserMessagesTableViewController.swift
//  Pet Records
//
/*
 List of Active Messages between User and User Contacts
 */
//  Created by Aaron Fulwider on 4/18/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit

class ActiveUserMessagesTableViewController: UITableViewController {
    
    var user: UserNSObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.setGradientBackground(Colors.lightBlue.cgColor, Colors.mediumBlue.cgColor, CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0))
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}

class ActiveUserMessagesTableViewCell : UITableViewCell {
    
    var profileImage = UIImageView()
    let name = UILabel()
    let email = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        uiSetup()
        layer.backgroundColor = UIColor.black.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func uiSetup(){
        addSubview(profileImage)
        addSubview(name)
        addSubview(email)
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        name.translatesAutoresizingMaskIntoConstraints = false
        email.translatesAutoresizingMaskIntoConstraints = false
        
        profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profileImage.layer.cornerRadius = 30
        profileImage.clipsToBounds = true
        
        name.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        name.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15).isActive = true
        name.widthAnchor.constraint(equalToConstant: 300).isActive = true
        name.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        email.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5).isActive = true
        email.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15).isActive = true
        email.widthAnchor.constraint(equalToConstant: 300).isActive = true
        email.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
}
