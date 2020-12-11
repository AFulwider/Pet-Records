//
//  HomeScreenViewController.swift
//  Pet Records

//  Created by Aaron Fulwider on 3/26/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class HomeScreenViewController: UIViewController, UITableViewDelegate {

    let toPetsTableButton = SignInButtonCustom()
    let toAppointmentsButton = SignInButtonCustom()
    let toVaccinesButton = SignInButtonCustom()
    let toGroomingButton = SignInButtonCustom()
    let backgroundImageView = UIImageView()
    
    let menuButton = UIButton()
    
    let petCollectionView = UICollectionView()
    
    let cellID = "cellID"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        petCollectionView.delegate = self
        petCollectionView.dataSource = self
        
        petCollectionView.register(petCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
//        checkIfUserIsLoggedIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in navigationController!.viewControllers {
            print("i.title: \(i)")
        }
        setupUI()
        view.backgroundColor = .white
        title = "Home"
    }
    
    func setupUI(){
        view.addSubview(backgroundImageView)
        view.addSubview(toPetsTableButton)
        view.addSubview(toAppointmentsButton)
        view.addSubview(toVaccinesButton)
        view.addSubview(toGroomingButton)
        
        view.addSubview(menuButton)

        toPetsTableButton.translatesAutoresizingMaskIntoConstraints = false
        toAppointmentsButton.translatesAutoresizingMaskIntoConstraints = false
        toVaccinesButton.translatesAutoresizingMaskIntoConstraints = false
        toGroomingButton.translatesAutoresizingMaskIntoConstraints = false
        
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.image = UIImage(named: "PawPrints")
        
        toPetsTableButton.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 20).isActive = true
        toPetsTableButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        toPetsTableButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        toPetsTableButton.setTitle("Pets", for: .normal)
        toPetsTableButton.addTarget(self, action: #selector(toPetsTableVCTapped), for: .touchUpInside)
        
        toAppointmentsButton.topAnchor.constraint(equalTo: toPetsTableButton.bottomAnchor, constant: 20).isActive = true
        toAppointmentsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        toAppointmentsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        toAppointmentsButton.setTitle("Appointments", for: .normal)
        toAppointmentsButton.addTarget(self, action: #selector(appointmentsTableViewButtonTapped), for: .touchUpInside)
        
        toVaccinesButton.topAnchor.constraint(equalTo: toAppointmentsButton.bottomAnchor, constant: 20).isActive = true
        toVaccinesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        toVaccinesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        toVaccinesButton.setTitle("Vaccine", for: .normal)
        toVaccinesButton.addTarget(self, action: #selector(vaccineTableViewButtonTapped), for: .touchUpInside)
        
        toGroomingButton.topAnchor.constraint(equalTo: toVaccinesButton.bottomAnchor, constant: 20).isActive = true
        toGroomingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        toGroomingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        toGroomingButton.setTitle("Grooming", for: .normal)
        toGroomingButton.addTarget(self, action: #selector(groomingTableViewButtonTapped), for: .touchUpInside)
        
        menuButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        menuButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: view.frame.height * 0.1).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: view.frame.height * 0.1).isActive = true
        
        menuButton.layer.cornerRadius = (view.frame.height * 0.1) / 2
        menuButton.layer.masksToBounds = true
        menuButton.backgroundColor = .black
        
        menuButton.setTitle("Menu", for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: [.touchUpInside, .touchDragExit])
    }
    
    @objc func menuButtonTapped() {
        let vc = MenuViewController()
        _ = navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - LOGOUT
    @objc func signOutTapped(){
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let vc = WelcomeViewController()
        let navigationController = self.navigationController
        navigationController?.setViewControllers([vc], animated:false)
    }
    
    // MARK: - TO PROFILE VC
    @objc func toProfileVCTapped(){
        let vc = UserProfileViewController()
        _ = navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - TO PETS TABLEVIEW
    @objc func toPetsTableVCTapped(){
        let vc = PetsTableViewController()
        _ = navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - TO APPOINTMENTS TABLEVIEW
    @objc func appointmentsTableViewButtonTapped(){
        let vc = AllPetAppointmentsTableViewController()
        _ = navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - TO APPOINTMENTS TABLEVIEW
    @objc func vaccineTableViewButtonTapped(){
        let vc = AllPetVaccinesTableViewController()
        _ = navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - TO APPOINTMENTS TABLEVIEW
    @objc func groomingTableViewButtonTapped(){
        let vc = AllPetGroomingsTableViewController()
        _ = navigationController?.pushViewController(vc, animated: true)
    }
    
    // Sets the title to the name of currently logged in user, after first making sure someone is logged in.
    func fetchUserAndSetupNavBarTitle(){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.navigationItem.title = dictionary["firstName"] as? String
            }
        }, withCancel: nil)
    }
}

extension HomeScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionViewUI () {
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = petCollectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! petCollectionViewCell
        return cell
    }
    
    
}

class petCollectionViewCell : UICollectionViewCell {
    let petImageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellUI() {
        
    }
}
