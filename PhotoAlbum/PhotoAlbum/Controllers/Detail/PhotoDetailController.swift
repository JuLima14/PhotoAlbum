//
//  PhotoDetailController.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 2/7/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit

class PhotoDetailController: UIViewController {

    var photoDetailView: PhotoDetailView!
    var photoDetailModelView: PhotoDetailModelView!
    
    var isHiddenDescriptionLabel: Bool = false {
        willSet(value){
            if let view = photoDetailView{
                if let label = view.descriptionLabel{
                    label.isHidden = value
                }
            }
        }
    }
    deinit {
        print("Deinit PhotoDetailController")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        CustomNavigationController.shared.hidesBarsOnSwipe = false
        if CustomNavigationController.shared.isNavigationBarHidden {
            CustomNavigationController.shared.setNavigationBarHidden(false, animated: true)
        }
    }
    
    func setupView(photo: PhotoDetailModelView!){
        photoDetailView = PhotoDetailView(photo: photo)
        view.addSubview(photoDetailView)
        photoDetailView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        photoDetailView.imageView.sd_setImage(with: URL(string: photo.item.url!)!, placeholderImage: nil) { (fetchedImage, error, cacheType, url) in
            if error != nil {
                print("Error loading Image from URL: \(String(describing: url!))\n\(String(describing: error?.localizedDescription))")
            }
        }
    }
}
