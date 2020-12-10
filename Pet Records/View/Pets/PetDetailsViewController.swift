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
    let profileImageView = UIImageView()
    let nameLabel = HeaderLabel()
    let breedLabel = UILabel()
    let genderLabel = UILabel()
    let dobLabel = UILabel()
    
    let vacTVLabel = UILabel()
    let appTVLabel = UILabel()
    let groomTVLabel = UILabel()
    
    let petVacVC = SinglePetVaccineViewController()
    let petAppVC = SinglePetAppointmentViewController()
    let petGroomVC = SinglePetGroomTableViewController()
    
    let scrollView = UIScrollView()
    var scrollViewHeight : CGFloat = 230
    
    var pet : Pet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        petVacVC.pet = pet
        petAppVC.pet = pet
        petGroomVC.pet = pet
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: view.frame.width, height: scrollViewHeight + 195)
        view.backgroundColor = .white
    }
    
    func setupUI() {
        view.addSubview(topView)
        view.addSubview(scrollView)
        
        topView.addSubview(profileImageView)
        topView.addSubview(nameLabel)
        topView.addSubview(breedLabel)
        topView.addSubview(genderLabel)
        topView.addSubview(dobLabel)
        
        scrollView.addSubview(petVacVC.view)
        scrollView.addSubview(petAppVC.view)
        scrollView.addSubview(petGroomVC.view)
        
        petVacVC.view.addSubview(vacTVLabel)
        petAppVC.view.addSubview(appTVLabel)
        petGroomVC.view.addSubview(groomTVLabel)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        breedLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        dobLabel.translatesAutoresizingMaskIntoConstraints = false
        
        vacTVLabel.translatesAutoresizingMaskIntoConstraints = false
        appTVLabel.translatesAutoresizingMaskIntoConstraints = false
        groomTVLabel.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        petVacVC.view.translatesAutoresizingMaskIntoConstraints = false
        petAppVC.view.translatesAutoresizingMaskIntoConstraints = false
        petGroomVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: TOPVIEW
        topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        profileImageView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 10).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 10).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.backgroundColor = .black
        
        nameLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 10).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        nameLabel.text = pet?.name
        
        breedLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        breedLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10).isActive = true
        breedLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        breedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        breedLabel.text = pet?.breed
        
        genderLabel.topAnchor.constraint(equalTo: breedLabel.bottomAnchor, constant: 5).isActive = true
        genderLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10).isActive = true
        genderLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        genderLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        genderLabel.text = pet?.gender
        
        dobLabel.topAnchor.constraint(equalTo: breedLabel.bottomAnchor, constant: 5).isActive = true
        dobLabel.leadingAnchor.constraint(equalTo: genderLabel.trailingAnchor, constant: 5).isActive = true
        dobLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        dobLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        dobLabel.textAlignment = .right
        dobLabel.text = pet?.dob
        
        //MARK: SCROLLVIEW
        scrollView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: view.frame.width, height: scrollViewHeight)
        
        //MARK: Vaccine TableView
        vacTVLabel.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        vacTVLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        vacTVLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        vacTVLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        vacTVLabel.text = "Vaccines"
        
        petVacVC.view.topAnchor.constraint(equalTo: vacTVLabel.bottomAnchor, constant: 1).isActive = true
        petVacVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        petVacVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        petVacVC.view.isUserInteractionEnabled = false
        
        //MARK: Appointments TableView
        appTVLabel.topAnchor.constraint(equalTo: petVacVC.view.bottomAnchor).isActive = true
        appTVLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        appTVLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        appTVLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        appTVLabel.text = "Appointments"
        
        petAppVC.view.topAnchor.constraint(equalTo: appTVLabel.bottomAnchor, constant: 1).isActive = true
        petAppVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        petAppVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        petAppVC.view.isUserInteractionEnabled = false
        
        //MARK: Grooming TableView
        groomTVLabel.topAnchor.constraint(equalTo: petAppVC.view.bottomAnchor).isActive = true
        groomTVLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        groomTVLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        groomTVLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        groomTVLabel.text = "Grooming"
        
        petGroomVC.view.topAnchor.constraint(equalTo: groomTVLabel.bottomAnchor, constant: 1).isActive = true
        petGroomVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        petGroomVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        petGroomVC.view.isUserInteractionEnabled = false
    }
}
