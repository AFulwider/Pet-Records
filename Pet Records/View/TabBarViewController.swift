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
    }
    
    func tabSetup() {
        let item1 = HomeScreenViewController()
        let icon1 = UITabBarItem(title: "Home", image: UIImage(named: "pp0"), tag: 0)
        let item2 = HomeScreenViewController()
        let icon2 = UITabBarItem(title: "Moon", image: UIImage(named: "pp4"), tag: 2)
        let item3 = HomeScreenViewController()
        let icon3 = UITabBarItem(title: "Yuna", image: UIImage(named: "pp9"), tag: 3)
        item1.tabBarItem = icon1
        item2.tabBarItem = icon2
        item3.tabBarItem = icon3
        let vcArray = [item1,item2,item3] // add more views as they become available
        self.viewControllers = vcArray
    }
}
