//
//  ViewController.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 2/7/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
    
    static let shared = CustomNavigationController()
    
    var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomNavigationController.shared.pushViewController(MainTabBarController(), animated: true)
        setupNav()
    }
    
    func setupNav(){
        titleLabel = {
            let label = UILabel(frame: CGRect.zero)
            label.font = UIFont.boldSystemFont(ofSize: 30)
            label.textAlignment = .natural
            return label
        }()
        CustomNavigationController.shared.navigationBar.addSubview(titleLabel)
        CustomNavigationController.shared.navigationBar.shadowImage = UIImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

