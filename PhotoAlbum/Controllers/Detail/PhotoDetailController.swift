//
//  PhotoDetailController.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 21/6/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//
import UIKit
import SDWebImage

class PhotoDetailController: UIViewController {
    
    let photoDetailView = PhotoDetailView(frame: .zero)
    
    var isHiddenDescriptionLabel: Bool = false {
        willSet(value){
            photoDetailView.descriptionLabel.isHidden = value
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupConstraints()
    }
    
    func loadStylePhotoDetailView(title: String){
        navigationController?.navigationBar.setTitleVerticalPositionAdjustment(0, for: .defaultPrompt)
        navigationController?.title = title
        navigationController?.navigationBar.tintColor = Stylesheet.shared.black
//        titleLabel.textColor = Stylesheet.shared.black
//        titleLabel.snp.removeConstraints()
//        changeShapeSwitch.isHidden = true
//        titleLabel.snp.makeConstraints { (make) in
//            make.centerX.centerY.equalToSuperview()
//        }
        navigationController?.navigationBar.barTintColor = Stylesheet.shared.red
    }
    
    func setup() {
        view.addSubview(photoDetailView)
    }

    func setupConstraints() {
        photoDetailView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func update(item: Any) {
        photoDetailView.update(item: item)
    }
    
    func prepareViewForPreviewing(){
        let diameter: CGFloat = view.frame.width
        preferredContentSize = CGSize(width: diameter, height: diameter)
        view.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: diameter, height: diameter))
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.frame.width / 2
        isHiddenDescriptionLabel = true
    }
}
