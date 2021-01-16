//
//  TabBarViewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 12/11/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import CloudKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        tabSetup()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
    }
    
    func tabSetup() {
        let item1 = HomeScreenViewController()
        let item2 = AllAppointmentsViewController()
        let item3 = PDFPreviewController()
        
        let icon1 = UITabBarItem(title: "Home", image: UIImage(named: "Box"), tag: 0)
        let icon2 = UITabBarItem(title: "Appointments", image: UIImage(named: "Box"), tag: 1)
        let icon3 = UITabBarItem(title: "Maps", image:  UIImage(named: "Box"), tag: 2)
        
        item1.tabBarItem = icon1
        item2.tabBarItem = icon2
        item3.tabBarItem = icon3
        
        let vcArray = [item1,item2,item3]
        self.viewControllers = vcArray
        self.tabBar.barTintColor = .white
        self.tabBar.tintColor = .red
    }
    
    @objc func logoutTapped() {
        let alert = UIAlertController(title: "Do you want to log out?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { action in
            do {
                try Auth.auth().signOut()
//                let vc = WelcomeViewController()
//                _ = self.navigationController?.pushViewController(vc, animated: true)
                
                
                
                let vc = WelcomeViewController()
                self.navigationController?.setViewControllers([vc], animated:false)
                
            }
            catch { print("already logged out")
            }
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
}
