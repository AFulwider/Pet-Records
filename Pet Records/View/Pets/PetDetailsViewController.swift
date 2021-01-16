//
//  PetDetailsViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/21/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import CloudKit

class PetDetailsViewController: UIViewController, UITabBarDelegate {
    
    var vaccines = [Vaccine]()
    var meds = [Medication]()
    var pet : Pet?
    
    let topView = UIView()
    let nameLabel = UILabel()
    let breedLabel = UILabel()
    let genderLabel = UILabel()
    let dobLabel = UILabel()
    let dataTableView = UITableView()
    let deletePetButton = UIButton()
    let pDFButton = UIButton()
    
    let cellID = "cellid"
    
    var genderString : String? = ""
    var breedString : String? = ""
    var dobString : String? = ""
    
    var values = [String:String]()
    let dataArray = ["Vaccines", "Appointments", "Grooming", "Medication", "Food", "Injuries"]
    
    var tableViewHeight : CGFloat? = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dataTableView.register(PetDetailsCell.self, forCellReuseIdentifier: cellID)
        setupUI()
        dataTableView.delegate = self
        dataTableView.dataSource = self
        tableViewUI()
        checkForProperties()
        loadVaccineTemp()
        loadMedicationTemp()
    }
    
    func loadVaccineTemp(){
        let uid = (Auth.auth().currentUser?.uid)!
        Database.database().reference().child("users").child(uid).child("pets").child(pet!.pid!).child("vaccines").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]   {
                let dict = Vaccine(dictionary : dictionary)
                self.vaccines.append(dict)
            }
        }
    }
    
    func loadMedicationTemp(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).child("pets").child(pet!.pid!).child("medication").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]   {
                let dictionary = Medication(dictionary : dictionary)
                self.meds.append(dictionary)
            }
        }
    }
    
    func setupUI() {
        view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        topView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 10).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 65).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        nameLabel.font = UIFont(name:"Chalkboard SE", size: 45)
        nameLabel.textAlignment = .center
        nameLabel.baselineAdjustment = .alignCenters
        nameLabel.lineBreakMode = .byClipping
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.text = pet?.name?.uppercased() ?? nil
        
        topView.addSubview(breedLabel)
        breedLabel.translatesAutoresizingMaskIntoConstraints = false
        breedLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        breedLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        breedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        breedLabel.widthAnchor.constraint(equalToConstant: view.frame.width/3).isActive = true
        breedLabel.font = UIFont(name:"Chalkboard SE", size:  30)
        breedLabel.textAlignment = .center
        breedLabel.numberOfLines = 0
        breedLabel.baselineAdjustment = .alignCenters
        breedLabel.adjustsFontSizeToFitWidth = true
        breedLabel.text = pet?.breed ?? ""
        
        topView.addSubview(genderLabel)
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        genderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        genderLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        genderLabel.trailingAnchor.constraint(equalTo: breedLabel.leadingAnchor, constant: -5).isActive = true
        genderLabel.font = UIFont(name:"Chalkboard SE", size: 12)
        genderLabel.textAlignment = .right
        genderLabel.baselineAdjustment = .alignCenters
        genderLabel.adjustsFontSizeToFitWidth = true
        genderLabel.text = pet?.gender ?? ""
        
        topView.addSubview(dobLabel)
        dobLabel.translatesAutoresizingMaskIntoConstraints = false
        dobLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        dobLabel.leadingAnchor.constraint(equalTo: breedLabel.trailingAnchor, constant: 5).isActive = true
        dobLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dobLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        dobLabel.font = UIFont(name:"Chalkboard SE", size: 15)
        dobLabel.adjustsFontSizeToFitWidth = true
        dobLabel.baselineAdjustment = .alignCenters
        dobLabel.textAlignment = .left
        dobLabel.text = pet?.dob ?? ""
        
        view.addSubview(deletePetButton)
        deletePetButton.translatesAutoresizingMaskIntoConstraints = false
        deletePetButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        deletePetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        deletePetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        deletePetButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        deletePetButton.backgroundColor = .systemRed
        deletePetButton.setTitle("DELETE", for: .normal)
        deletePetButton.addTarget(self, action: #selector(deletePetButtonTapped), for: .touchUpInside)
        
        view.addSubview(pDFButton)
        pDFButton.translatesAutoresizingMaskIntoConstraints = false
        pDFButton.bottomAnchor.constraint(equalTo: deletePetButton.topAnchor).isActive = true
        pDFButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pDFButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pDFButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        pDFButton.backgroundColor = .systemBlue
        pDFButton.setTitle("PDF", for: .normal)
        pDFButton.addTarget(self, action: #selector(toPDF), for: .touchUpInside)
    }
    
    @objc func toPDF() {
        let vc = PDFPreviewController()
        vc.pet = pet
        vc.medication = meds
        vc.vaccine = vaccines
        _ = navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func deletePetButtonTapped() {
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete \(pet?.name ?? "") from your account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in _ = self.navigationController?.popViewController(animated: true) }))
        alert.addAction(UIAlertAction(title: "DELETE", style: .destructive, handler: { [self] (action) in
            let uid = Auth.auth().currentUser?.uid
            let ref = Database.database().reference().child("users").child(uid!).child("pets").child((pet?.pid)!)
            ref.removeValue()
            let vc = TabBarViewController()
            self.navigationController?.setViewControllers([vc], animated:false)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func checkForProperties() {
        if genderLabel.text == "" || breedLabel.text == "" || dobLabel.text == "" {
            let alert = UIAlertController(title: "Please fill out the required fields.", message: "", preferredStyle: .alert)
            if genderLabel.text == "" { alert.addTextField { (textField) in textField.placeholder = "GENDER" } }
            if breedLabel.text == "" { alert.addTextField { (textField) in textField.placeholder = "BREED" } }
            if dobLabel.text == "" { alert.addTextField { (textField) in textField.placeholder = "DATE OF BIRTH" } }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (action) in
                self.genderString = alert?.textFields![0].text ?? ""
                self.breedString = alert?.textFields![1].text ?? ""
                self.dobString = alert?.textFields![2].text ?? ""
                self.saveToPet() }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func saveToPet() {
        let uid = Auth.auth().currentUser?.uid
        if genderString != "" {
            values["gender"] = genderString
            pet?.gender = genderString
        }
        
        if breedString != "" {
            values["breed"] = breedString
            pet?.gender = breedString
        }
        
        if dobString != "" {
            values["dob"] = dobString
            pet?.gender = dobString
        }
        let ref = Database.database().reference().child("users").child(uid!).child("pets").child((pet?.pid)!)
        DispatchQueue.main.async(execute: {
            ref.updateChildValues(self.values)
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
        return CGFloat(tableViewHeight!)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        switch row {
        case 0: // Vaccine
            // Title, Description, Time
            let vc = VaccinesTableViewController()
            vc.pet = pet
            vc.title = "Vaccines"
            _ = navigationController?.pushViewController(vc, animated: true)
        case 1: // Appointments
            // Title, Description, Time
            let vc = SinglePetAppointmentsViewController()
            vc.pet = pet
            vc.title = "Appointments"
            _ = navigationController?.pushViewController(vc, animated: true)
        case 2: // Grooming
            // Title, Description, Time
            let vc = GroomingTableViewController()
            vc.pet = pet
            vc.title = "Grooming"
            _ = navigationController?.pushViewController(vc, animated: true)
        case 3: // Medication
            // Title, Description
            let vc = MedicationTableViewController()
            vc.pet = pet
            vc.title = "Medication"
            _ = navigationController?.pushViewController(vc, animated: true)
        case 4: // Food
            // Title, Description
            let vc = FoodTableViewController()
            vc.pet = pet
            vc.title = "Food"
            _ = navigationController?.pushViewController(vc, animated: true)
        case 5: // Injuries
            // Title, Description
            let vc = InjuriesTableViewController()
            vc.pet = pet
            vc.title = "Injuries"
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
        dataTableView.heightAnchor.constraint(equalToConstant: CGFloat(dataArray.count) * tableViewHeight!).isActive = true
        dataTableView.layer.borderWidth = 1
        dataTableView.layer.borderColor = UIColor.black.cgColor
        dataTableView.isScrollEnabled = false
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
