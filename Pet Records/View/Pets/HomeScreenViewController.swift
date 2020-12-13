//
//  HomeScreenViewController.swift
//  Pet Records

//  Created by Aaron Fulwider on 3/26/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase

class HomeScreenViewController: UIViewController, UITableViewDelegate {
    
    let backgroundImageView = UIImageView()
    let menuButton = UIButton()
    let cellID = "cellID"
    
    let bottomLabel = UITextView()
    
    enum petPics:String {
        case pp0,pp1,pp2,pp3,pp4,pp5,pp6,pp7,pp8,pp9
    }
    
    let petCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        for i in navigationController!.viewControllers {
//            print("i.title: \(i)")
//        }
        topUI()
        collectionViewUI()
        bottomUI()
        view.backgroundColor = .white
        title = "Home"
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
        
        bottomLabel.text =
            "Dogs: 5\n" +
            "Cats: 1\n" +
            "Other: 88\n" +
            "Appointments Pending: 1\n" +
            "Vaccines Due: 0\n" +
            "Pets need grooming: 9"
        
        bottomLabel.backgroundColor = UIColor(red: 0.1, green: 0.4, blue: 0.9, alpha: 0.5)
    }
    
    @objc func menuButtonTapped() {
        let vc = MenuViewController()
        view.addSubview(vc)
        vc.translatesAutoresizingMaskIntoConstraints = false
        vc.backgroundColor = .blue
        vc.topAnchor.constraint(equalTo: petCollectionView.bottomAnchor, constant: 5).isActive = true
        vc.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
        vc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        vc.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
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
        petCollectionView.backgroundColor = .black
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! petCollectionViewCell
        
        if indexPath.row < 49 {
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
}

class petCollectionViewCell : UICollectionViewCell {
    let petImageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: .zero)
        cellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellUI() {
        addSubview(petImageView)
        petImageView.translatesAutoresizingMaskIntoConstraints = false
        
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
    }
}
