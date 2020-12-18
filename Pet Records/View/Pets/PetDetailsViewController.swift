//
//  PetDetailsViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/21/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class PetDetailsViewController: UIViewController, UITabBarDelegate {
    
    let topView = UIView()
    let nameLabel = UILabel()
    let breedLabel = UILabel()
    let genderLabel = UILabel()
    let dobLabel = UILabel()
    let cellID = "cellid"
    let dataTableView = UITableView()
    
    
    var alertTextFieldGender : String? = nil
    var alertTextFieldBreed : String? = nil
    var alertTextFieldDoB : String? = nil
    
    var pet : Pet?
    let deletePetButton = UIButton()
    
    let dataArray = ["Vaccines", "Appointments", "Grooming", "Basics"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dataTableView.register(PetDetailsCell.self, forCellReuseIdentifier: cellID)
        setupUI()
        dataTableView.delegate = self
        dataTableView.dataSource = self
        tableViewUI()
        checkForProperties()
    }
    
    func setupUI() {
        view.addSubview(topView)
        
        topView.addSubview(nameLabel)
        topView.addSubview(breedLabel)
        topView.addSubview(genderLabel)
        topView.addSubview(dobLabel)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        breedLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        dobLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: TOPVIEW
        topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 10).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 65).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        nameLabel.font = UIFont(name:"Chalkboard SE", size: 50)
        nameLabel.textAlignment = .center
//        nameLabel.backgroundColor = .systemBlue
        nameLabel.baselineAdjustment = .alignCenters
        nameLabel.lineBreakMode = .byClipping
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.text = pet?.name
        
        genderLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        genderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        genderLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        genderLabel.trailingAnchor.constraint(equalTo: breedLabel.leadingAnchor, constant: -5).isActive = true
        genderLabel.font = UIFont(name:"Chalkboard SE", size: 20)
        genderLabel.textAlignment = .left
        genderLabel.baselineAdjustment = .alignCenters
        genderLabel.adjustsFontSizeToFitWidth = true
//        genderLabel.backgroundColor = .systemGreen
        genderLabel.text = pet?.gender
        
        breedLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        breedLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        breedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        breedLabel.widthAnchor.constraint(equalToConstant: view.frame.width/3).isActive = true
        breedLabel.font = UIFont(name:"Chalkboard SE", size: 50)
        breedLabel.textAlignment = .center
//        breedLabel.backgroundColor = .systemRed
        breedLabel.numberOfLines = 1
        breedLabel.baselineAdjustment = .alignCenters
        breedLabel.adjustsFontSizeToFitWidth = true
        breedLabel.text = pet?.breed
        
        dobLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        dobLabel.leadingAnchor.constraint(equalTo: breedLabel.trailingAnchor, constant: 5).isActive = true
        dobLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dobLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        dobLabel.font = UIFont(name:"Chalkboard SE", size: 20)
        dobLabel.adjustsFontSizeToFitWidth = true
        dobLabel.baselineAdjustment = .alignCenters
        dobLabel.textAlignment = .right
//        dobLabel.backgroundColor = .systemPurple
        dobLabel.text = pet?.dob
        tempUI()
    }
    
    func tempUI() {
        view.addSubview(deletePetButton)
        deletePetButton.translatesAutoresizingMaskIntoConstraints = false
        
        deletePetButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        deletePetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        deletePetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        deletePetButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        deletePetButton.backgroundColor = .systemRed
        deletePetButton.setTitle("DELETE", for: .normal)
        
        deletePetButton.addTarget(self, action: #selector(basicButtonTapped), for: .touchUpInside)
    }
    
    @objc func basicButtonTapped() {
        let vc = BasicsViewController()
        vc.pet = pet
        _ = navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    
    
    
    
    func checkForProperties() {
        print("outside of statement")
        if genderLabel.text == "" , breedLabel.text == "" , dobLabel.text == "" {
            print("inside of statement")
            let alert = UIAlertController(title: "Please fill out the required fields.", message: "", preferredStyle: .alert)
            
            if genderLabel.text == "" {
                alert.addTextField { (textField) in
                    textField.placeholder = "GENDER"
                    self.alertTextFieldGender = textField.text!
                }
            }
            
            if breedLabel.text == "" {
                alert.addTextField { (textField) in
                    textField.placeholder = "BREED"
                    self.alertTextFieldBreed = textField.text!
                }
            }
            
            if dobLabel.text == "" {
                alert.addTextField { (textField) in
                    textField.placeholder = "DATE OF BIRTH"
                    self.alertTextFieldDoB = textField.text!
                }
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in _ = self.navigationController?.popViewController(animated: true) }))
            
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (action) in
                
                
                self.alertTextFieldGender = (alert?.textFields![0].text)!
                self.alertTextFieldBreed! = (alert?.textFields![1].text)!
                self.alertTextFieldDoB! = (alert?.textFields![2].text)!
                self.saveToPet()
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func saveToPet() {
        let uid = Auth.auth().currentUser?.uid
        var values = [String:String]()
        
        if alertTextFieldGender != nil {
            values["gender"] = alertTextFieldGender!
        }
        
        if alertTextFieldBreed != nil {
            values["breed"] = alertTextFieldBreed!
        }
        
        if alertTextFieldDoB != nil {
            values["dob"] = alertTextFieldDoB!
        }
        
        print("values: \(values)")
        let ref = Database.database().reference().child("users").child(uid!).child("pets").child((pet?.pid)!)
        DispatchQueue.main.async(execute: {
            ref.updateChildValues(values)
            self.view.reloadInputViews()
        })
    }
}

extension PetDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PetDetailsCell
        
        cell.titleLabel.text = dataArray[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        switch row {
        case 0:
            let vc = AllPetVaccinesTableViewController()
            vc.pet = pet
            _ = navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = AllPetAppointmentsTableViewController()
            vc.pet = pet
            _ = navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = AllPetGroomingsTableViewController()
            vc.pet = pet
            _ = navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = BasicsViewController()
            vc.pet = pet
            _ = navigationController?.pushViewController(vc, animated: true)
        default:
            print("default")
        }
    }
    
    func tableViewUI() {
        view.addSubview(dataTableView)
        dataTableView.translatesAutoresizingMaskIntoConstraints = false
        dataTableView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 30).isActive = true
        dataTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        dataTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        dataTableView.bottomAnchor.constraint(equalTo: deletePetButton.topAnchor).isActive = true
        dataTableView.separatorStyle = .none
        dataTableView.layer.borderWidth = 1
        dataTableView.layer.borderColor = UIColor.black.cgColor
    }
}

class PetDetailsCell : UITableViewCell {
    let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        titleLabel.textAlignment = .center
    }
}
