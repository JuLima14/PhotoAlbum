//
//  ViewController.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 2/7/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit

protocol UISwitchDelegate {
    func switchStateChanged(value: Bool)
}

class CustomNavigationController: UINavigationController {
    
    static let shared = CustomNavigationController()
    
    var titleLabel: UILabel!
    var changeShapeSwitch: UISwitch!
    var switchDelegate: UISwitchDelegate?
    
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
        changeShapeSwitch = {
            let view = UISwitch(frame: CGRect.zero)
            view.addTarget(self, action: #selector(self.handleSwitch(_:)), for: .valueChanged)
            return view
        }()
        CustomNavigationController.shared.navigationBar.addSubview(titleLabel)
        CustomNavigationController.shared.navigationBar.addSubview(changeShapeSwitch)
        CustomNavigationController.shared.navigationBar.shadowImage = UIImage()
    }
    @objc func handleSwitch(_ sender : UISwitch!){
        print(sender.isOn)
        switchDelegate?.switchStateChanged(value: sender.isOn)
    }
    func loadStyleCollectionView(title: String){
        titleLabel.text = title
        titleLabel.textColor = UIColor.black
        titleLabel.snp.removeConstraints()
        changeShapeSwitch.isHidden = true
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.left.equalToSuperview().inset(20)
        }
        topViewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
        topViewController?.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    func loadStyleListView(title: String){
        titleLabel.text = title
        titleLabel.textColor = UIColor.black
        titleLabel.snp.removeConstraints()
        changeShapeSwitch.isHidden = false
        changeShapeSwitch.snp.removeConstraints()
        changeShapeSwitch.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.left.equalToSuperview().inset(20)
        }
        topViewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
        topViewController?.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    func loadStylePhotoDetailView(title: String){
        titleLabel.text = title
        titleLabel.textColor = UIColor.black
        titleLabel.snp.removeConstraints()
        changeShapeSwitch.isHidden = true
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(closeViewController))
        topViewController?.navigationItem.leftBarButtonItem = button
        topViewController?.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    @objc func closeViewController(){
        self.popViewController(animated: true)
    }

}

