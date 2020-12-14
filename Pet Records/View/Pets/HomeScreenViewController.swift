//
//  HomeScreenViewController.swift
//  Pet Records

//  Created by Aaron Fulwider on 3/26/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class HomeScreenViewController: UIViewController, UITableViewDelegate {
    
    var petArray = [Pet?]()
    let backgroundImageView = UIImageView()
    let menuButton = UIButton()
    let bottomLabel = UITextView()
    let cellID = "cellID"
    let petCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    let divider = UIView()

    let alert = NewPetUIView()
    var alertBool : Bool = false
    
    func fetchUserPets() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("user_pets").child(uid!).observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]   {
                let pet = Pet(dictionary : dictionary)
                self.petArray.append(pet)
                DispatchQueue.main.async(execute: {
                    self.petCollectionView.reloadData()
                })
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topUI()
        collectionViewUI()
        bottomUI()
        fetchUserPets()
        view.backgroundColor = .white
    }
    
    func topUI(){
        view.addSubview(backgroundImageView)
        view.addSubview(menuButton)
        
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.image = UIImage(named: "PawPrints")
        
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
    
    func bottomUI() {
        view.addSubview(bottomLabel)
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.topAnchor.constraint(equalTo: petCollectionView.bottomAnchor).isActive = true
        bottomLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bottomLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomLabel.textColor = .systemPurple
        bottomLabel.isUserInteractionEnabled = false
        bottomLabel.backgroundColor = UIColor(red: 0.1, green: 0.4, blue: 0.9, alpha: 0.5)
        bottomLabel.text =
            "Dogs: 5\n" +
            "Cats: 1\n" +
            "Other: 88\n" +
            "Appointments Pending: 1\n" +
            "Vaccines Due: 0\n" +
            "Pets need grooming: 9"
    }
    
    @objc func menuButtonTapped() {
        if !alertBool {
            alert.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            self.view.setNeedsLayout()
        } else {
            alertBool = false
            alert.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.width).isActive = true
            self.view.setNeedsLayout()
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
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
}

extension HomeScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionViewUI() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: view.frame.width/6, height: view.frame.width/6)
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 4, bottom: 10, right: 4)
        
        petCollectionView.delegate = self
        petCollectionView.dataSource = self
        petCollectionView.register(petCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        petCollectionView.collectionViewLayout = flowLayout
        view.addSubview(petCollectionView)
        
        petCollectionView.translatesAutoresizingMaskIntoConstraints = false
        petCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        petCollectionView.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        petCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        petCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        petCollectionView.backgroundColor = UIColor(red: 0/255, green: 100/255, blue: 255/255, alpha: 0.5)
        
        view.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.topAnchor.constraint(equalTo: petCollectionView.bottomAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 3).isActive = true
        divider.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        divider.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        divider.backgroundColor = .black
        
        view.addSubview(alert)
        alert.translatesAutoresizingMaskIntoConstraints = false
        
        alert.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        alert.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        alert.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.width).isActive = true
        alert.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! petCollectionViewCell
        if indexPath.row < petArray.count {
            let row = indexPath.row
            cell.abbLabel.text = petArray[row]?.name
            let rand = Int.random(in: 1...10)
            switch rand {
            case 0:
                cell.petImageView.image = UIImage(named: "pp0")
            case 1:
                cell.petImageView.image = UIImage(named: "pp1")
            case 2:
                cell.petImageView.image = UIImage(named: "pp2")
            case 3:
                cell.petImageView.image = UIImage(named: "pp3")
            case 4:
                cell.petImageView.image = UIImage(named: "pp4")
            case 5:
                cell.petImageView.image = UIImage(named: "pp5")
            case 6:
                cell.petImageView.image = UIImage(named: "pp6")
            case 7:
                cell.petImageView.image = UIImage(named: "pp7")
            case 8:
                cell.petImageView.image = UIImage(named: "pp8")
            case 9:
                cell.petImageView.image = UIImage(named: "pp9")
            default:
                cell.petImageView.image = UIImage(named: "pp0")
            }
        } else {
            cell.petImageView.image = .add
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("indexpath.row:\(indexPath.row), petArray.count: \(petArray.count)")
        if indexPath.row == petArray.count {
            let vc = AddPetViewController()
            _ = navigationController?.pushViewController(vc, animated: true)
        } else {
            if let pet = petArray[indexPath.row] {
                let vc = PetDetailsViewController()
                vc.pet = pet
                vc.view.backgroundColor = .white
                _ = navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //    @objc func openAlertView() {
    //        if !alertBool {
    //            UIView.animate(withDuration: 2) {
    //                self.alert.bottomAnchor.constraint(equalTo: self.petCollectionView.bottomAnchor).isActive = true
    //            }
    //        } else {
    //            UIView.animate(withDuration: 2) {
    //                self.alert.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    //            }
    //        }
    //    }
}

class petCollectionViewCell : UICollectionViewCell {
    let petImageView = UIImageView()
    let abbLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        cellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellUI() {
        addSubview(petImageView)
        addSubview(abbLabel)
        petImageView.translatesAutoresizingMaskIntoConstraints = false
        abbLabel.translatesAutoresizingMaskIntoConstraints = false
        
        petImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        petImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        petImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        petImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        petImageView.backgroundColor = .white
        petImageView.contentMode = .scaleToFill
        
        petImageView.image?.withTintColor(Colors.lightBrown, renderingMode: .alwaysTemplate)
        
        petImageView.layer.cornerRadius = 4
        petImageView.layer.borderWidth = 0.4
        petImageView.layer.borderColor = UIColor.white.cgColor
        
        abbLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        abbLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        abbLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        abbLabel.textColor = .systemGray
        abbLabel.textAlignment = .center
    }
}
