//
//  AddAppointmentViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/22/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Firebase
import CoreLocation

class AddAppointmentViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var appointments = [Appointment?]()
    
    var pets = [Pet?]()
    var currentPet : Pet?
    //    let mapView = MKMapView()
    var locationManager:CLLocationManager!
    var activeTextField = UITextField()
    let helpLabel = UILabel()
    
    let petCellId = "cellid"
    
    let toolBar = UIToolbar(frame:CGRect(x:0, y:0, width:100, height:100))
    
    let titleTF = UITextField()
    let timeTF = UITextField()
    let locationTF = UITextField()
    let petSelectButton = UIButton()
    let petListView = UIView()
    let petListCancelButton = UIButton()
    let petListTV = UITableView()
    
    let submitButton = SignInButtonCustom()
    let cancelButton = SignInButtonCustom()
    var petSelectedBool = Bool()
    var petSelectViewBool = Bool()
    
    func loadPets() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("user_pets").child(uid!).observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]   {
                let pet = Pet(dictionary : dictionary)
                self.pets.append(pet)
                DispatchQueue.main.async(execute: {
                    self.petListTV.reloadData()
                })
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPets()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Appointments"
        setupUI()
        petSelectedBool = false
        petSelectViewBool = false
        petListTV.delegate = self
        petListTV.dataSource = self
        petListTV.register(PetSelectCell.self, forCellReuseIdentifier: petCellId)
        view.backgroundColor = .white
    }
    
    @objc func doneButtonTapped() {
        activeTextField.resignFirstResponder()
    }
    
    let appTimeDatePicker: UIDatePicker = {
        let picker = UIDatePicker.init()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(startDateValueChanged), for: .valueChanged)
        return picker
    }()
    
    @objc func startDateValueChanged(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        timeTF.text = dateFormatter.string(from: sender.date)
    }
    
    func setupUI(){
        view.addSubview(cancelButton)
        view.addSubview(submitButton)
        view.addSubview(timeTF)
        view.addSubview(titleTF)
        //        view.addSubview(mapView)
        view.addSubview(locationTF)
        view.addSubview(helpLabel)
        view.addSubview(petSelectButton)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        timeTF.translatesAutoresizingMaskIntoConstraints = false
        titleTF.translatesAutoresizingMaskIntoConstraints = false
        //        mapView.translatesAutoresizingMaskIntoConstraints = false
        locationTF.translatesAutoresizingMaskIntoConstraints = false
        helpLabel.translatesAutoresizingMaskIntoConstraints = false
        petSelectButton.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100).isActive = true // CANCEL BUTTON
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.setTitle("Cancel", for: .normal)
        
        submitButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10).isActive = true // SUBMIT BUTTON
        submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        submitButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        submitButton.setTitle("Submit", for: .normal)
        // MARK: MAPVIEW UI
        //        mapView.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -20).isActive = true
        //        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //        mapView.heightAnchor.constraint(equalToConstant: view.frame.width * 0.7).isActive = true
        //        mapView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.7).isActive = true
        //        mapView.layer.borderColor = UIColor.gray.cgColor
        //        mapView.isMultipleTouchEnabled = true
        //        mapView.contentMode = .scaleToFill
        //        mapView.layer.borderWidth = 3
        //        mapView.mapType = .standard
        //        mapView.delegate = self
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.barStyle = UIBarStyle.default
        toolBar.tintColor = UIColor.black
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        locationTF.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -20).isActive = true
        locationTF.leadingAnchor.constraint(equalTo: submitButton.leadingAnchor).isActive = true
        locationTF.trailingAnchor.constraint(equalTo: submitButton.trailingAnchor).isActive = true
        locationTF.inputAccessoryView = toolBar
        locationTF.delegate = self
        
        petSelectButton.bottomAnchor.constraint(equalTo: locationTF.topAnchor, constant: -10).isActive = true
        petSelectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        petSelectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        petSelectButton.backgroundColor = Colors.mediumPurple
        petSelectButton.setTitle("select pet", for: .normal)
        petSelectButton.addTarget(self, action: #selector(selectPetForApp), for: .touchUpInside)
        
        timeTF.bottomAnchor.constraint(equalTo: petSelectButton.topAnchor, constant: -10).isActive = true
        timeTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        timeTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        timeTF.inputView = appTimeDatePicker
        timeTF.delegate = self
        timeTF.inputAccessoryView = toolBar
        
        titleTF.bottomAnchor.constraint(equalTo: timeTF.topAnchor, constant: -10).isActive = true
        titleTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        titleTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        titleTF.inputAccessoryView = toolBar
        titleTF.delegate = self
        
        helpLabel.bottomAnchor.constraint(equalTo: titleTF.topAnchor, constant: -10).isActive = true
        helpLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        helpLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        helpLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 26)
        helpLabel.text = "HI! Fill out the textfields below to complete your appointment form."
        helpLabel.textColor = Colors.darkBrown
        helpLabel.textAlignment = .justified
        helpLabel.numberOfLines = 0
        petListUISetup()
        petListView.isHidden = true
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
    
    @objc func petListCancelButtonTapped() {
        petListView.isHidden = true
        petSelectViewBool = false
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        helpLabel.text = "HI! Fill out the textfields below to complete your appointment form."
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
        helpLabel.textColor = Colors.darkBrown
        switch activeTextField {
        case titleTF:
            helpLabel.text = "Enter the title for your appointment."
        case timeTF:
            helpLabel.text = "What time would you like for your appointment?"
        case locationTF:
            helpLabel.text = "Where will this appointment be taking you?"
        case petSelectButton:
            helpLabel.text = "Here is where you will either select the pets you would like to bring with you. If your pet is not listed, you will be asked if you would like to add this pet to the database. Please separate pets with a \",\""
        default:
            helpLabel.text = ""
        }
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveData(/*_ lat: CLLocationDegrees, _ lon: CLLocationDegrees*/){
        if titleTF.text != "" && timeTF.text != "" && locationTF.text != "" && petSelectedBool == true {
            if let uid = Auth.auth().currentUser?.uid {
                let ref = Database.database().reference().child("user_appointments").child(uid)
                let childRef = ref.childByAutoId()
                let appValues = ["app_id" : childRef.key!, "title" : titleTF.text!, "time" : timeTF.text!, "pet_id" : currentPet?.pid! as Any, "location" : locationTF.text!, "pet_name" : currentPet?.name! as Any] as [String : Any]
                childRef.updateChildValues(appValues)
                
                _ = navigationController?.popViewController(animated: true)
            }
        } else {
            // Textfields not filled out properly
            helpLabel.textColor = .red
            helpLabel.text = "Please fill out the required textfields!"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: petCellId, for: indexPath) as! PetSelectCell
        cell.name.text = pets[indexPath.row]?.name
        cell.breed.text = pets[indexPath.row]?.breed
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pet = pets[indexPath.row]
        petSelectButton.setTitle(pet!.name, for: .normal)
        currentPet = pet
        petListView.isHidden = true
        petSelectViewBool = false
        petSelectedBool = true
    }
    
    // MARK: MAPVIEW FUNCTIONS
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //        print("Location Search")
    //        let activityIndicator = UIActivityIndicatorView()
    //        activityIndicator.style = .medium
    //        activityIndicator.center = view.center
    //        activityIndicator.hidesWhenStopped = true
    //        activityIndicator.startAnimating()
    //        view.addSubview(activityIndicator)
    //        searchBar.resignFirstResponder()
    //        dismiss(animated: true, completion: nil)
    //        let searchRequest = MKLocalSearch.Request()
    //        searchRequest.naturalLanguageQuery = searchBar.text
    //        let activeSearch = MKLocalSearch(request: searchRequest)
    //        activeSearch.start { (response, error) in
    //            activityIndicator.stopAnimating()
    //            activityIndicator.isUserInteractionEnabled = false
    //            //            UIApplication.shared.endIgnoringInteractionEvents()
    //            if response == nil {
    //                print(error!)
    //            } else {
    //                let annotations = self.mapView.annotations
    //                self.mapView.removeAnnotations(annotations)
    //                let latitude = response?.boundingRegion.center.latitude
    //                let longitude = response?.boundingRegion.center.longitude
    //                let annotation = MKPointAnnotation()
    //                annotation.title = self.searchBar.text
    //                print("annotation: \(annotation)")
    //                print("annotation title: \(String(describing: annotation.title))")
    //                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
    //                self.mapView.addAnnotation(annotation)
    //                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
    //                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    //                let region = MKCoordinateRegion(center: coordinate, span: span)
    //                self.mapView.setRegion(region, animated: true)
    //                print("user latitude = \(String(describing: latitude))")
    //                print("user longitude = \(String(describing: longitude))")
    //                self.saveData(latitude!, longitude!)
    //            }
    //        }
    //        return true
    //    }
    
    //    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
    //        let annotationView = views.first!
    //        if let annotation = annotationView.annotation {
    //            if annotation is MKUserLocation {
    //                var region = MKCoordinateRegion()
    //                region.center = self.mapView.userLocation.coordinate
    //                region.span.latitudeDelta = 0.025
    //                region.span.longitudeDelta = 0.025
    //                self.mapView.setRegion(region, animated: true)
    //                populateNearByPlaces()
    //            }
    //        }
    //    }
    
    //    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    //        let annotation = view.annotation as! PlaceAnnotation
    //        mapsViewControllerDidSelectAnnotation(mapItem: annotation.mapItem)
    //    }
    //
    //    func mapsViewControllerDidSelectAnnotation(mapItem: MKMapItem) {
    //        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10.0, options: .curveEaseIn, animations: {
    //            self.view.layoutIfNeeded()
    //        }) { (true) in
    //            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10.0, options: .curveEaseIn, animations: {
    //                self.view.layoutIfNeeded()
    //            }, completion: nil)
    //        }
    //    }
    
    //    func populateNearByPlaces() {
    //        var region = MKCoordinateRegion()
    //        region.center = CLLocationCoordinate2D(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
    //        let request = MKLocalSearch.Request()
    //        //        request.naturalLanguageQuery = self.place.title
    //        request.region = region
    //        let search = MKLocalSearch(request: request)
    //        search.start { (response, error) in
    //            guard let response = response else {
    //                return
    //            }
    //            for item in response.mapItems {
    //                let annotation = PlaceAnnotation()
    //                annotation.coordinate = item.placemark.coordinate
    //                annotation.title = item.name
    //                annotation.mapItem = item
    //                DispatchQueue.main.async {
    //                    self.mapView.addAnnotation(annotation)
    //                }
    //            }
    //        }
    //    }
    
    
    //    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    //    {
    //        print("Error \(error)")
    //    }
    
    //    func determineMyCurrentLocation() {
    //        locationManager = CLLocationManager()
    //        locationManager.delegate = self
    //        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    //        locationManager.requestAlwaysAuthorization()
    //        if CLLocationManager.locationServicesEnabled() {
    //            locationManager.startUpdatingLocation()
    //            locationManager.startUpdatingHeading() // was commented out
    //        }
    //    }
    
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        let userLocation:CLLocation = locations[0] as CLLocation
    //        // Call stopUpdatingLocation() to stop listening for location updates,
    //        // other wise this function will be called every time when user location changes.
    //        // manager.stopUpdatingLocation()
    //        print("user latitude = \(userLocation.coordinate.latitude)")
    //        print("user longitude = \(userLocation.coordinate.longitude)")
    //    }
}

class PetSelectCell: UITableViewCell {
    let name = UILabel()
    let breed = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        uiSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func uiSetup(){
        addSubview(name)
        addSubview(breed)
        name.translatesAutoresizingMaskIntoConstraints = false
        breed.translatesAutoresizingMaskIntoConstraints = false
        
        name.trailingAnchor .constraint(equalTo: centerXAnchor, constant: -1).isActive = true
        name.widthAnchor.constraint(equalToConstant: frame.width/2).isActive = true
        name.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        name.textAlignment = .center
        
        breed.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 1).isActive = true
        breed.widthAnchor.constraint(equalToConstant: frame.width/2).isActive = true
        breed.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        breed.textAlignment = .center
    }
}
