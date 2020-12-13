//
//  TabBarViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 12/11/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabSetup()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cog"), style: .plain, target: self, action: #selector(settingsTapped))
        
    }
    
    func tabSetup() {
        let item1 = HomeScreenViewController()
        let icon1 = UITabBarItem(title: "Home", image: .none, tag: 0)
        item1.tabBarItem = icon1
        
        
        let item2 = HomeScreenViewController()
        let icon2 = UITabBarItem(title: "Appointments", image: .none, tag: 1)
        item2.tabBarItem = icon2
        
        let item3 = HomeScreenViewController()
        let icon3 = UITabBarItem(title: "POI", image: .none, tag: 2)
        item3.tabBarItem = icon3
        
        let vcArray = [item1,item2,item3] // add more views as they become available
        self.viewControllers = vcArray
    }
    
    @objc func settingsTapped() {
        let vc = SettingsViewController()
        _ = navigationController?.pushViewController(vc, animated: true)
    }
}
