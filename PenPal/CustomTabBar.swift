//
//  CustomTabBar.swift
//  PenPal
//
//  Created by Will Cohen on 7/26/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

class CustomTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        (tabBar.items![0]).selectedImage = UIImage(named: "DictionaryFilled")?.withRenderingMode(.alwaysOriginal)
        (tabBar.items![1]).selectedImage = UIImage(named: "ChatFilled")?.withRenderingMode(.alwaysOriginal)
        (tabBar.items![2]).selectedImage = UIImage(named: "HomeFilled")?.withRenderingMode(.alwaysOriginal)
        (tabBar.items![3]).selectedImage = UIImage(named: "CorrectionsFilled")?.withRenderingMode(.alwaysOriginal)
        (tabBar.items![4]).selectedImage = UIImage(named: "SettingsFilled")?.withRenderingMode(.alwaysOriginal)
        
        tabBar.unselectedItemTintColor = UIColor.black
        tabBar.barTintColor = UIColor.white
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        self.selectedIndex = 2
        for vc in self.viewControllers! {
            vc.tabBarItem.title = nil
            vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        }
        
    }

    

}
