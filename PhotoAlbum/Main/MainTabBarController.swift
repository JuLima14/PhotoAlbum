//
//  MainTabBarController.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 19/6/18.
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
        
        let cvc = CollectionViewController()
        let lvc = ListViewController()
        
        cvc.tabBarItem = UITabBarItem(title: "collectionView", image: collectionIcon, tag: 1)
        lvc.tabBarItem = UITabBarItem(title: "listView", image: listIcon, tag: 2)
        
        viewControllers = [lvc,cvc]  
    }

}

