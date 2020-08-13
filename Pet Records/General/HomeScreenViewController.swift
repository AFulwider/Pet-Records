//
//  HomeScreenViewController.swift
//  Pet Records

//  Created by Aaron Fulwider on 3/26/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SideMenu

class HomeScreenViewController: UIViewController, UITableViewDelegate {
    let toContactsButton = SigninButtonCustom()
    let toPetsTableButton = SigninButtonCustom()
    let toAppointmentsButton = SigninButtonCustom()
    let toVaccinesButton = SigninButtonCustom()
    let toGroomingButton = SigninButtonCustom()
    let backgroundImageView = UIImageView()
    
    
    
    
    
    
    
    var menu : SideMenuNavigationController?
    
    
    
    
    
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIfUserIsLoggedIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.title = "TITLE"
        
        
        
        
        
        
        

        
        
        
        
        
        
        

        menu = SideMenuNavigationController(rootViewController: SideMenuTableViewController())
        
        
        
        
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: false)
        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
        
        

        
        
        
        
        
        
        

        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.setGradientBackground(Colors.lightBlue.cgColor, Colors.mediumBlue.cgColor, CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0))
    }
    
    func setupUI(){
        
        if let window = UIApplication.shared.delegate?.window {
            var viewController = window!.rootViewController
            if(viewController is UINavigationController) {
                viewController = (viewController as! UINavigationController).visibleViewController
            }
            
            if(viewController is HomeScreenViewController) {
//                print("viewcontroller : \(navigationController?.navigationItem.title)")
            }
        }
        
        view.addSubview(backgroundImageView)
        view.addSubview(toContactsButton)
        view.addSubview(toPetsTableButton)
        view.addSubview(toAppointmentsButton)
        view.addSubview(toVaccinesButton)
        view.addSubview(toGroomingButton)
        toContactsButton.translatesAutoresizingMaskIntoConstraints = false
        toPetsTableButton.translatesAutoresizingMaskIntoConstraints = false
        toAppointmentsButton.translatesAutoresizingMaskIntoConstraints = false
        toVaccinesButton.translatesAutoresizingMaskIntoConstraints = false
        toGroomingButton.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.image = UIImage(named: "PawPrints")
        
        toContactsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        toContactsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        toContactsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        toContactsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        toContactsButton.setTitle("Connections", for: .normal)
        toContactsButton.addTarget(self, action: #selector(toContactsVCTapped), for: .touchUpInside)
        
        toPetsTableButton.topAnchor.constraint(equalTo: toContactsButton.bottomAnchor, constant: 20).isActive = true
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
    }
    
    // MARK: - LOGOUT
    @objc func signOutTapped(){
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let vc = WelcomeScreenViewController()
        let navigationController = self.navigationController
        navigationController?.setViewControllers([vc], animated:false)
    }
    
    // MARK: - TO PROFILE VC
    @objc func toProfileVCTapped(){
        let vc = UserProfileViewController()
        _ = navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - TO CONTACTS VC
    @objc func toContactsVCTapped(){
        let vc = ContactsTableViewController()
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
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil{
            perform(#selector(signOutTapped), with: nil, afterDelay: 0)
        } else {
            
     
            
            // slide out menu
//            let menuButton = UIButton()
//            menuButton.frame = CGRect(x: 100, y: 100, width: 53, height: 51)
//            menuButton.setImage(UIImage(named: "menu-hamburger"), for: .normal)
//            menuButton.addTarget(self, action: #selector(didTapMenu), for: .touchUpInside)
            
//            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
            
//            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(toProfileVCTapped))
//            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutTapped))
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "SOM", style: .plain, target: self, action: #selector(didTapMenu))
//            fetchUserAndSetupNavBarTitle()
        }
    }
    
    @objc func didTapMenu() {
        present(menu!, animated: true)
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
