//
//  MainTabViewController.swift
//  payporte-v2
//
//  Created by SimpuMind on 6/29/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = UIColor(red: 35/255, green: 35/255, blue: 35/255.0, alpha: 1)
        
        tabBar.isTranslucent = false
        
        //35 35 35
        setupBarItems()
        
        tabBar.items?.forEach({ (item) -> () in
            item.image = item.selectedImage?.imageWithColor(color1: UIColor.black).withRenderingMode(.alwaysOriginal)
        })
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = primaryColor
        
        let tabBarItemApperance = UITabBarItem.appearance()
        tabBarItemApperance.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Orkney-Medium", size: 10)!, NSForegroundColorAttributeName:UIColor.black], for: .normal)
        tabBarItemApperance.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Orkney-Medium", size: 10)!, NSForegroundColorAttributeName: primaryColor], for: .selected)
    }
    
    
    private func setupBarItems(){
        let controller1 = HomeVC()
        controller1.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "home"), tag: 1)
        let nav1 = UINavigationController(rootViewController: controller1)
        nav1.toolbar.isHidden = true
        
        let controller2 = StoresVC()
        controller2.tabBarItem = UITabBarItem(title: "Stores", image: #imageLiteral(resourceName: "store"), tag: 2)
        let nav2 = UINavigationController(rootViewController: controller2)
        
        let controller3 = CartVC()
        controller3.tabBarItem = UITabBarItem(title: "Cart", image: #imageLiteral(resourceName: "cart"), tag: 3)
        
        let nav3 = UINavigationController(rootViewController: controller3)
        nav3.title = ""
        
        let controller4 = ProfileVC()
        controller4.tabBarItem = UITabBarItem(title: "Account", image: #imageLiteral(resourceName: "profile"), tag: 4)
        let nav4 = UINavigationController(rootViewController: controller4)
        
        viewControllers = [nav1, nav2, nav3, nav3, nav4]
        
    }

}
