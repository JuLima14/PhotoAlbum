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
    func loadStyleCollectionView(title: String){
        titleLabel.text = title
        titleLabel.textColor = UIColor.black
        self.titleLabel.snp.removeConstraints()
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.left.equalToSuperview().inset(20)
        }
        self.topViewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
        self.topViewController?.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    func loadStylePhotoDetailView(title: String){
        titleLabel.text = title
        titleLabel.textColor = UIColor.black
        titleLabel.snp.removeConstraints()
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(closeViewController))
        topViewController?.navigationItem.leftBarButtonItem = button
        topViewController?.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    @objc func closeViewController(){
        self.popViewController(animated: true)
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: true)
        
        if viewController.isKind(of: CollectionViewController.self){
            loadStyleCollectionView(title: "Album")
        }
        if viewController.isKind(of: PhotoDetailController.self){
            loadStylePhotoDetailView(title: "Photo Detail")
        }
    }

}

