//
//  PetVaccinesViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/29/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class AllPetVaccinesTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    let vaccineCellId = "vacCell"
    var vaccines = [Vaccine?]()
    var pet : Pet?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vaccines.removeAll()
        loadVaccines()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addVaccineTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(backButton))
        tableView.register(VacineTableViewCell.self, forCellReuseIdentifier: vaccineCellId)
        title = "Vaccines"
        view.backgroundColor = .white
    }
    
    func loadVaccines(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("user_vaccines").child(uid!).observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]   {
                let vac = Vaccine(dictionary : dictionary)
                self.vaccines.append(vac)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    @objc func backButton(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addVaccineTapped(){
        let vc = AddVaccineViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - TABLEVIEW
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vaccines.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: vaccineCellId, for: indexPath) as! VacineTableViewCell
        cell.titleLabel.textColor = .black
        cell.startDateLabel.textColor = Colors.darkPurple
        cell.titleLabel.text = vaccines[indexPath.row]?.title
        //            cell.setGradientBackground(Colors.lightPurple, .clear, CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5))
        cell.startDateLabel.text = vaccines[indexPath.row]?.startDate
        cell.endDateLabel.text = vaccines[indexPath.row]?.endDate
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    @objc func addVaccineButtonTapped(){
        let vc = AddVaccineViewController()
        _ = navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - cell class
class VacineTableViewCell: UITableViewCell {
    let titleLabel   = UILabel()
    let startDateLabel   = UILabel()
    let endDateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        uiSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    func uiSetup(){
        addSubview(startDateLabel)
        addSubview(endDateLabel)
        addSubview(titleLabel)
        
        startDateLabel.translatesAutoresizingMaskIntoConstraints  = false
        endDateLabel.translatesAutoresizingMaskIntoConstraints  = false
        titleLabel.translatesAutoresizingMaskIntoConstraints  = false
        
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: frame.width/2).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.baselineAdjustment = .alignCenters
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .left
        
        startDateLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        startDateLabel.widthAnchor.constraint(equalToConstant: frame.width/4).isActive = true
        startDateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        startDateLabel.baselineAdjustment = .alignCenters
        startDateLabel.adjustsFontSizeToFitWidth = true
        startDateLabel.textAlignment = .center
        
        endDateLabel.leadingAnchor.constraint(equalTo: startDateLabel.trailingAnchor).isActive = true
        endDateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        endDateLabel.widthAnchor.constraint(equalToConstant: frame.width/4).isActive = true
        endDateLabel.baselineAdjustment = .alignCenters
        endDateLabel.adjustsFontSizeToFitWidth = true
        endDateLabel.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
