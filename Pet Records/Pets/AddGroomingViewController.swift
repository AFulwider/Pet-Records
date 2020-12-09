//
//  AddGroomingViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/22/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class AddGroomingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let titleTF = UITextField()
    let dateTF = UITextField()
    
    var activeTextField = UITextField()
    let helpLabel = UILabel()
    
    let submitButton = SignInButtonCustom()
    let cancelButton = SignInButtonCustom()
    
    let petSelectButton = UIButton()
    let petListView = UIView()
    let petListCancelButton = UIButton()
    let petListTV = UITableView()
    
    var petSelectedBool = Bool()
    var petSelectViewBool = Bool()
    
    
    let toolBar = UIToolbar(frame:CGRect(x:0, y:0, width:100, height:100))
    
    var petObjects = [Pet?]()
    var currentPet : Pet?
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(startDateValueChanged), for: .valueChanged)
        return picker
    }()
    
    @objc func startDateValueChanged(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateTF.text = dateFormatter.string(from: sender.date)
    }
    
    let petCellId = "cellid"
    
    func fetchVaccine() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("user_pets").child(uid!).observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]   {
                let pet = Pet(dictionary : dictionary)
                self.petObjects.append(pet)
                DispatchQueue.main.async(execute: {
                    self.petListTV.reloadData()
                })
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchVaccine()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        petListTV.register(PetSelectCell.self, forCellReuseIdentifier: petCellId)
        title = "Grooming"
        petSelectedBool = false
        petSelectViewBool = false
        setupUI()
        petListUISetup()
        petListTV.delegate = self
        petListTV.dataSource = self
        petListView.isHidden = true
    }
    
    func setupUI(){
        view.addSubview(titleTF)
        view.addSubview(dateTF)
        view.addSubview(submitButton)
        view.addSubview(cancelButton)
        view.addSubview(helpLabel)
        view.addSubview(petSelectButton)
        
        titleTF.translatesAutoresizingMaskIntoConstraints = false
        dateTF.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        helpLabel.translatesAutoresizingMaskIntoConstraints = false
        petSelectButton.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        submitButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10).isActive = true
        submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let nowButton = UIBarButtonItem(title: "Now", style: .plain, target: self, action: #selector(nowButtonTapped))
        toolBar.setItems([spaceButton, spaceButton, nowButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        toolBar.barStyle = .default
        toolBar.tintColor = .black
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        petSelectButton.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -10).isActive = true
        petSelectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        petSelectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        petSelectButton.backgroundColor = Colors.mediumPurple
        petSelectButton.setTitle("select pet", for: .normal)
        petSelectButton.addTarget(self, action: #selector(selectPetForApp), for: .touchUpInside)
        
        Utilities.styleTextFields(textfield: dateTF, placeholder:"Groom Date", secureTextEntry:false)
        dateTF.bottomAnchor.constraint(equalTo: petSelectButton.topAnchor, constant: -20).isActive = true
        dateTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        dateTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        dateTF.inputAccessoryView = toolBar
        dateTF.inputView = datePicker
        
        Utilities.styleTextFields(textfield: titleTF, placeholder:"Title", secureTextEntry:false)
        titleTF.bottomAnchor.constraint(equalTo: dateTF.topAnchor, constant: -20).isActive = true
        titleTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        titleTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        helpLabel.bottomAnchor.constraint(equalTo: titleTF.topAnchor, constant: -10).isActive = true
        helpLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        helpLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        helpLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 26)
        helpLabel.text = "HI! Fill out the textfields below to complete your appointment form."
        helpLabel.textColor = Colors.darkBrown
        helpLabel.textAlignment = .justified
        helpLabel.numberOfLines = 0
    }
    
    func petListUISetup() {
        view.addSubview(petListView)
        petListView.addSubview(petListTV)
        petListView.addSubview(petListCancelButton)
        petListView.translatesAutoresizingMaskIntoConstraints = false
        petListTV.translatesAutoresizingMaskIntoConstraints = false
        petListCancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        petListView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        petListView.bottomAnchor.constraint(equalTo: petSelectButton.topAnchor, constant: -5).isActive = true
        petListView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        petListView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        petListView.backgroundColor = .white
        
        petListCancelButton.topAnchor.constraint(equalTo: petListView.topAnchor, constant: 1).isActive = true
        petListCancelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        petListCancelButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        petListCancelButton.trailingAnchor.constraint(equalTo: petListView.trailingAnchor, constant: 2).isActive = true
        
        petListCancelButton.addTarget(self, action: #selector(petListCancelButtonTapped), for: .touchDown)
        petListCancelButton.setTitle("Cancel", for: .normal)
        petListCancelButton.layer.cornerRadius = 5
        
        petListTV.topAnchor.constraint(equalTo: petListCancelButton.bottomAnchor, constant: 2).isActive = true
        petListTV.bottomAnchor.constraint(equalTo: petListView.bottomAnchor, constant: -2).isActive = true
        petListTV.leadingAnchor.constraint(equalTo: petListView.leadingAnchor, constant: 2).isActive = true
        petListTV.trailingAnchor.constraint(equalTo: petListView.trailingAnchor, constant: -2).isActive = true
    }
    
    @objc func selectPetForApp() {
        if petSelectViewBool {
            petListView.isHidden = true
            petSelectViewBool = false
        } else {
            petListView.isHidden = false
            petSelectViewBool = true
        }
    }
    
    @objc func petListCancelButtonTapped() {
        petListView.isHidden = true
        petSelectViewBool = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: petCellId, for: indexPath) as! PetSelectCell
        cell.name.text = petObjects[indexPath.row]?.name
        cell.breed.text = petObjects[indexPath.row]?.breed
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pet = petObjects[indexPath.row]
        petSelectButton.setTitle(pet!.name, for: .normal)
        currentPet = pet
        petListView.isHidden = true
        petSelectViewBool = false
        petSelectedBool = true
    }
    
    @objc func cancelButtonTapped() {
        
    }
    
    @objc func doneButtonTapped() {
        dateTF.resignFirstResponder()
    }
    
    @objc func nowButtonTapped() {
        dateTF.text = DateHelper.dateToString("MMMM dd, yyyy - hh:mm", Date())
        dateTF.resignFirstResponder()
    }
    
    @objc func saveData(/*_ lat: CLLocationDegrees, _ lon: CLLocationDegrees*/){
        if titleTF.text != "" && dateTF.text != "" && petSelectedBool == true {
            if let uid = Auth.auth().currentUser?.uid {
                let ref = Database.database().reference().child("user_grooming").child(uid)
                let childRef = ref.childByAutoId()
                let appValues = ["groom_id" : childRef.key!, "title" : titleTF.text!, "time" : dateTF.text!, "pet_id" : currentPet?.pid! as Any] as [String : Any]
                childRef.updateChildValues(appValues)
                
                _ = navigationController?.popViewController(animated: true)
            }
        } else {
            // Textfields not filled out properly
            helpLabel.textColor = .red
            helpLabel.text = "Please fill out the required textfields!"
        }
    }
}
