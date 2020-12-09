//
//  ContactProfileViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/18/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit

class ContactProfileViewController: UIViewController {
    
    var user: User? {
        didSet {
            navigationController?.title = user?.firstName
        }
    }
    
    let titleLabel = UILabel()
    let toChatButton = SignInButtonCustom()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleLabel)
        view.addSubview(toChatButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        toChatButton.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleLabel.backgroundColor = .lightText
        titleLabel.text = user?.firstName
        titleLabel.textAlignment = .center
        
        toChatButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        toChatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        toChatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        toChatButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toChatButton.addTarget(self, action: #selector(toChat), for: .touchUpInside)
        toChatButton.setTitle("To Chat", for: .normal)
        view.backgroundColor = .white
    }
    
    @objc func toChat(){
//        let vc = SendMessagesViewController(collectionViewLayout: UICollectionViewFlowLayout())
//        vc.user = user
//        _ = navigationController?.pushViewController(vc, animated: true)
    }
}
