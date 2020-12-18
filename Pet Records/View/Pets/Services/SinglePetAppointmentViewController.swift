//
//  AppointmentsViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/11/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class SinglePetAppointmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var appointments = [Appointment?]()
    let appointmentTableView = UITableView()
    var pet : Pet?
    let cellid = "cellid"
    
    func loadPetDetails(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("user_appointments").child(uid!).observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]   {
                if snapshot.childSnapshot(forPath: "pet_id").value as! String == (self.pet?.pid)! {
                    let dict = Appointment(dictionary : dictionary)
                    self.appointments.append(dict)
                    DispatchQueue.main.async(execute: {
                        self.appointmentTableView.reloadData()
                    })
                }
            }
        }
    }
    
    func setupUI() {
        view.addSubview(appointmentTableView)
        appointmentTableView.translatesAutoresizingMaskIntoConstraints = false
        appointmentTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        appointmentTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        appointmentTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        appointmentTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        appointmentTableView.separatorInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        appointmentTableView.delegate = self
        appointmentTableView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appointmentTableView.register(AppointmentsTableViewCell.self, forCellReuseIdentifier: cellid)
        loadPetDetails()
        setupUI()
    }
    
    // MARK: - Table view data source
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("appointments.count: \(appointments.count)")
        return appointments.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! AppointmentsTableViewCell
        let appointment = appointments[indexPath.row]!
        cell.title.text = appointment.title
        cell.petName.text = appointment.petName
        cell.time.text = appointment.time
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

class AppointmentsTableViewCell: UITableViewCell {
    let petName = UILabel()
    let title = UILabel()
    let time = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        uiSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
