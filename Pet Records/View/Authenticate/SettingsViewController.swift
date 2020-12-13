//
//  SettingsViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 12/12/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import Firebase


class SettingsViewController: UIViewController {

    let logOutButton = UIButton()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
    }
    
    func setupUI() {
        
    }
}
