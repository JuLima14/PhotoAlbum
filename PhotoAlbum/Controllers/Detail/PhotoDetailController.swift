//
//  PhotoDetailController.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 21/6/18.
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
    override func viewWillAppear(_ animated: Bool) {
        CustomNavigationController.shared.loadStylePhotoDetailView(title: "Photo Detail")
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
    func prepareViewForPreviewing(){
        let diameter: CGFloat = view.frame.width
        preferredContentSize = CGSize(width: diameter, height: diameter)
        view.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: diameter, height: diameter))
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.frame.width / 2
        isHiddenDescriptionLabel = true
    }
}
