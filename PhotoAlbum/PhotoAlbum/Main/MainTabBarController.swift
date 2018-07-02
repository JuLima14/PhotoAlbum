//
//  MainTabBarControllerViewController.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 2/7/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let collectionIcon = UIImage(named: "collection_view"), let listIcon = UIImage(named: "list_view") else {
            print("One or multiple tab bar images couldn't be loaded.")
            return
        }
        
        let cvc = UIViewController()
        let lvc = UIViewController()
        
        cvc.tabBarItem = MainTabBarItem(title: "collectionView", image: collectionIcon, tag: 1)
        lvc.tabBarItem = MainTabBarItem(title: "listView", image: listIcon, tag: 2)
        
        viewControllers = [cvc,lvc]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
