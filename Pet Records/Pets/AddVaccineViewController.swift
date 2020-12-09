//
//  AddVaccineViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/22/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class AddVaccineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var petArray = [Pet?]()
    var currentPet : Pet?
    
    let titleTF = UITextField()
    let startTimeTF = UITextField()
    let endTimeTF = UITextField()
    let toolBar = UIToolbar(frame:CGRect(x:0, y:0, width:100, height:100))
    let toolBar2 = UIToolbar(frame:CGRect(x:0, y:0, width:100, height:100))
    
    var activeTextField = UITextField()
    let helpLabel = UILabel()
    
    let submitButton = SignInButtonCustom()
    let cancelButton = SignInButtonCustom()
    let errorLabel = UILabel()
    
    let petSelectButton = UIButton()
    let petListView = UIView()
    let petListCancelButton = UIButton()
    let petListTV = UITableView()
    
    var petSelectedBool = Bool()
    var petSelectViewBool = Bool()
    let petCellId = "cellid"
    
    func fetchVaccine() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("user_pets").child(uid!).observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]   {
                let pet = Pet(dictionary : dictionary)
                self.petArray.append(pet)
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
        title = "Vaccines"
        petSelectedBool = false
        petSelectViewBool = false
        setupUI()
        petListUISetup()
        petListTV.delegate = self
        petListTV.dataSource = self
        petListView.isHidden = true
        view.backgroundColor = .white
    }
    
    func loadPet(){
        
    }
    
    let startDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var minComponents = DateComponents()
        minComponents.calendar = calendar
        minComponents.year = -10
        var maxComponents = DateComponents()
        maxComponents.calendar = calendar
        maxComponents.year = 10
        let minDate = calendar.date(byAdding: minComponents, to: currentDate)
        let maxDate = calendar.date(byAdding: maxComponents, to: currentDate)
        picker.datePickerMode = .date
        picker.minimumDate = minDate
        picker.maximumDate = maxDate
        picker.addTarget(self, action: #selector(dateValueChanged), for: .valueChanged)
        return picker
    }()
    
    let endDatePicker: UIDatePicker = {
        let picker = UIDatePicker.init()
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var minComponents = DateComponents()
        minComponents.calendar = calendar
        minComponents.year = -10
        var maxComponents = DateComponents()
        maxComponents.calendar = calendar
        maxComponents.year = 10
        let minDate = calendar.date(byAdding: minComponents, to: currentDate)
        let maxDate = calendar.date(byAdding: maxComponents, to: currentDate)
        picker.datePickerMode = .date
        picker.minimumDate = minDate
        picker.maximumDate = maxDate
        picker.addTarget(self, action: #selector(dateValueChanged), for: .valueChanged)
        return picker
    }()
    
    func setupUI(){
        view.addSubview(cancelButton)
        view.addSubview(submitButton)
        view.addSubview(endTimeTF)
        view.addSubview(startTimeTF)
        view.addSubview(titleTF)
        view.addSubview(errorLabel)
        view.addSubview(helpLabel)
        view.addSubview(petSelectButton)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        endTimeTF.translatesAutoresizingMaskIntoConstraints = false
        startTimeTF.translatesAutoresizingMaskIntoConstraints = false
        titleTF.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        helpLabel.translatesAutoresizingMaskIntoConstraints = false
        petSelectButton.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        submitButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10).isActive = true
        submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        
        // TODO: - ADD "TODAY" BUTTON
        let doneButton = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(doneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let todayButton = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(todayButtonTapped))
        toolBar.setItems([spaceButton, spaceButton, todayButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        toolBar.barStyle = .default
        toolBar.tintColor = .black
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        toolBar2.setItems([spaceButton, doneButton], animated: true)
        toolBar2.isUserInteractionEnabled = true
        toolBar2.barStyle = .default
        toolBar2.tintColor = .black
        toolBar2.isTranslucent = true
        toolBar2.sizeToFit()
        
        petSelectButton.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -10).isActive = true
        petSelectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        petSelectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        petSelectButton.backgroundColor = Colors.mediumPurple
        petSelectButton.setTitle("select pet", for: .normal)
        petSelectButton.addTarget(self, action: #selector(selectPetForApp), for: .touchUpInside)
        
        Utilities.styleTextFields(textfield: endTimeTF, placeholder:"End Date", secureTextEntry:false)
        endTimeTF.bottomAnchor.constraint(equalTo: petSelectButton.topAnchor, constant: -20).isActive = true
        endTimeTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        endTimeTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        endTimeTF.inputView = endDatePicker
        endTimeTF.inputAccessoryView = toolBar
        
        Utilities.styleTextFields(textfield: startTimeTF, placeholder:"Start Date", secureTextEntry:false)
        startTimeTF.bottomAnchor.constraint(equalTo: endTimeTF.topAnchor, constant: -10).isActive = true
        startTimeTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        startTimeTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        startTimeTF.inputView = startDatePicker
        startTimeTF.inputAccessoryView = toolBar
        
        Utilities.styleTextFields(textfield: titleTF, placeholder:"Vaccine", secureTextEntry:false)
        titleTF.bottomAnchor.constraint(equalTo: startTimeTF.topAnchor, constant: -10).isActive = true
        titleTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        titleTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        titleTF.text = nil
        titleTF.inputAccessoryView = toolBar2
        
        errorLabel.bottomAnchor.constraint(equalTo: titleTF.topAnchor, constant: -40).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        errorLabel.numberOfLines = 0
        errorLabel.alpha = 0
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        
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
        return petArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: petCellId, for: indexPath) as! PetSelectCell
        cell.name.text = petArray[indexPath.row]?.name
        cell.breed.text = petArray[indexPath.row]?.breed
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pet = petArray[indexPath.row]
        petSelectButton.setTitle(pet!.name, for: .normal)
        currentPet = pet
        petListView.isHidden = true
        petSelectViewBool = false
        petSelectedBool = true
    }
    
    @objc func dateValueChanged(_ sender: UIDatePicker){
        if sender == startDatePicker {
            let string = DateHelper.dateToString("MMMM dd, yyyy", sender.date)
            startTimeTF.text = string
        }
        if sender == endDatePicker{
            let string = DateHelper.dateToString("MMMM dd, yyyy", sender.date)
            endTimeTF.text = string
        }
    }
    
    @objc func cancelButtonTapped() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func todayButtonTapped() {
        if startTimeTF.isFirstResponder {
            startTimeTF.text = DateHelper.dateToString("MMMM dd, yyyy", Date())
            startTimeTF.resignFirstResponder()
        }
        if endTimeTF.isFirstResponder {
            endTimeTF.text = DateHelper.dateToString("MMMM dd, yyyy", Date())
            endTimeTF.resignFirstResponder()
        }
    }
    
    @objc func doneButtonTapped() {
        startTimeTF.resignFirstResponder()
        endTimeTF.resignFirstResponder()
        titleTF.resignFirstResponder()
    }
    
    @objc func saveData(/*_ lat: CLLocationDegrees, _ lon: CLLocationDegrees*/){
        if titleTF.text != "" && startTimeTF.text != "" && endTimeTF.text != "" && petSelectedBool == true {
            if let uid = Auth.auth().currentUser?.uid {
                let ref = Database.database().reference().child("user_vaccines").child(uid)
                let childRef = ref.childByAutoId()
                let appValues = ["vac_id" : childRef.key!, "title" : titleTF.text!, "start_time" : startTimeTF.text!, "end_time" : endTimeTF.text!, "pet_id" : currentPet?.pid! as Any] as [String : Any]
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
