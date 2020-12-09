//
//  SideMenuTableViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 6/19/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import SideMenu
import Firebase

class SideMenuTableViewController: UITableViewController {

    let sideMenuItems = ["Profile", "Connections", "Appointments", "Vaccines", "Groomings", "Settings", "Logout"]
    let cellID = "cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        title = "TITLE"
                self.navigationItem.title = "TITLE"
//        tableView.reloadData()
        tableView.register(SideMenuTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sideMenuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SideMenuTableViewCell
        cell.linkLabel.text = sideMenuItems[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: // Profile
            sideMenuProfileTapped()
        case 1: // Contacts
            sideMenuContactsTapped()
        case 2: // Appointments
            sideMenuAppointmentsTapped()
        case 3: // Vaccines
            sideMenuVaccineTapped()
        case 4: // Groomings
        let vc = AllPetGroomingsTableViewController()
        _ = navigationController?.pushViewController(vc, animated: true)
        //case 5: // Settings
            // TODO: - go to viewcontroller to adjust in-app settings
        case 6: // Logout
            sideMenuSignOutTapped()
        default:
            print("Something hapened with the side menu items inside the SideMenuTableViewController.swift")
        }
    }

    func sideMenuProfileTapped() {
        let vc = UserProfileViewController()
        _ = navigationController?.pushViewController(vc, animated: false)
    }

    func sideMenuContactsTapped() {
        let vc = ContactsTableViewController()
        _ = navigationController?.pushViewController(vc, animated: false)
    }

    func sideMenuAppointmentsTapped() {
        let vc = AllPetAppointmentsTableViewController()
        _ = navigationController?.pushViewController(vc, animated: false)
    }

    func sideMenuVaccineTapped() {
        let vc = AllPetVaccinesTableViewController()
        _ = navigationController?.pushViewController(vc, animated: false)
    }

    func sideMenuSignOutTapped() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let vc = WelcomeViewController()
        let navigationController = self.navigationController
        navigationController?.setViewControllers([vc], animated:false)
    }
}

class SideMenuTableViewCell : UITableViewCell {
    
    let linkLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(linkLabel)
        linkLabel.translatesAutoresizingMaskIntoConstraints = false
        linkLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        linkLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        linkLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        linkLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        linkLabel.textAlignment = .center
        linkLabel.adjustsFontSizeToFitWidth = true
        linkLabel.backgroundColor = Colors.mediumBlue
    }
}
