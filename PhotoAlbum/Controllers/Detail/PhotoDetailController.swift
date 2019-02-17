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
    
    func setup(photo: PhotoDetailModelView) {
        
        photoDetailView.update(item: photo)
        view.addSubview(photoDetailView)
        
        photoDetailView.imageView.sd_setImage(with: URL(string: photo.item.url)!, placeholderImage: nil, options: .progressiveDownload, progress:
        { (receivedSize, expectedSize, targetURL) in
            //set percentage load
        }) { [weak self] (fetchedImage, error, cacheType, url) in
            
            if error != nil {
                print("Error loading Image from URL: \(String(describing: url!))\n\(String(describing: error?.localizedDescription))")
            }
            
            if url?.absoluteString == photo.item.url, let strongSelf = self {
                strongSelf.photoDetailView.imageView.image = fetchedImage
            }
        }
    }
    
    func setupConstraints() {
        photoDetailView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
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
