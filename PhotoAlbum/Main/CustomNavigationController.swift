//
//  CustomNavigationController.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 21/6/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit

protocol UISwitchDelegate {
    func switchStateChanged(value: Bool)
}

class CustomNavigationController: UINavigationController {
    
    static let shared = CustomNavigationController()
    private var titleLabel: UILabel!
    private var changeShapeSwitch: UISwitch!
    var switchDelegate: [String:UISwitchDelegate] = [String:UISwitchDelegate]()

    override func viewDidLoad() {
        super.viewDidLoad()
        CustomNavigationController.shared.pushViewController(MainTabBarController(), animated: true)
        setupNav()
    }

    func addSwitchDelegate(_ key: String, value : UISwitchDelegate){
        self.switchDelegate[key] = value
    }
    
    func removeSwitchDelegate(key: String){
        self.switchDelegate[key] = nil
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
        //is setted here to avoid move it when the titleLabel is animated when push/pop is executed
        changeShapeSwitch.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
        }
    }
    
    @objc func handleSwitch(_ sender : UISwitch!){
            for key in self.switchDelegate.keys{
                    self.switchDelegate[key]?.switchStateChanged(value: sender.isOn)
            }
        sender.onTintColor = Stylesheet.shared.darkGray
    }
    
    func loadStyleCollectionView(title: String){
        titleLabel.text = title
        titleLabel.textColor = Stylesheet.shared.white
        titleLabel.snp.removeConstraints()
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8 , options: UIViewAnimationOptions.curveLinear, animations: {
            self.titleLabel.snp.remakeConstraints { (make) in
                make.top.bottom.right.equalToSuperview()
                make.left.equalToSuperview().inset(20)
            }
            CustomNavigationController.shared.navigationBar.layoutIfNeeded()
        }) { (true) in }
        
        topViewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
        topViewController?.navigationController?.navigationBar.barTintColor = Stylesheet.shared.red
    }
    func loadStyleListView(title: String){
        titleLabel.text = title
        titleLabel.textColor = Stylesheet.shared.white
        titleLabel.snp.removeConstraints()
        changeShapeSwitch.isHidden = false
        changeShapeSwitch.snp.removeConstraints()
        changeShapeSwitch.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
        }
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.curveLinear, animations: {
            self.titleLabel.snp.remakeConstraints { (make) in
                make.top.bottom.right.equalToSuperview()
                make.left.equalToSuperview().inset(20)
            }
            CustomNavigationController.shared.navigationBar.layoutIfNeeded()
        }) { (true) in }

        topViewController?.navigationController?.navigationBar.barTintColor = Stylesheet.shared.red
    }
    func loadStylePhotoDetailView(title: String){
        titleLabel.text = title
        titleLabel.textColor = Stylesheet.shared.black
        titleLabel.snp.removeConstraints()
        changeShapeSwitch.isHidden = true
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        topViewController?.navigationController?.navigationBar.barTintColor = Stylesheet.shared.red
    }
    //this is coupling the behavior
//    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        super.pushViewController(viewController, animated: animated)
//        if viewController.isKind(of: PhotoDetailController.self){
//            CustomNavigationController.shared.loadStylePhotoDetailView(title: "Photo Detail")
//            CustomNavigationController.shared.hidesBarsOnSwipe = false
//            if CustomNavigationController.shared.isNavigationBarHidden {
//                CustomNavigationController.shared.setNavigationBarHidden(false, animated: true)
//            }
//        }
//    }
    //this is coupling the behavior
    override func popViewController(animated: Bool) -> UIViewController? {
        super.popViewController(animated: true)
        let vc = visibleViewController
        if let lastvc = vc{
            if lastvc.isKind(of: ListViewController.self){
                CustomNavigationController.shared.setNavigationBarHidden(false, animated: false)
            }else if lastvc.isKind(of: CollectionViewController.self){
                CustomNavigationController.shared.hidesBarsOnSwipe = false
                CustomNavigationController.shared.setNavigationBarHidden(false, animated: false)
            }
        }
        return vc
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
