//
//  PhotoDetailView.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 2/7/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit

class PhotoDetailView: UIView {

    var imageView: UIImageView!
    var descriptionLabel: UILabel!
    
    init(photo: PhotoDetailModelView) {
        super.init(frame: .zero)
        setupPhotosCollectionView(photo: photo)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhotosCollectionView(photo: PhotoDetailModelView){
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.white
        imageView = {
            let view = UIImageView(frame: CGRect.zero)
            view.contentMode = .scaleAspectFit
            view.backgroundColor = UIColor.white
            return view
        }()
        descriptionLabel = {
            let view = UILabel(frame: CGRect.zero)
            view.font = UIFont.boldSystemFont(ofSize: 18)
            view.textColor = UIColor.black
            view.text = photo.item.title
            view.numberOfLines = 0
            
            return view
        }()
        addSubview(imageView)
        addSubview(descriptionLabel)
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.centerY.left.right.equalToSuperview()
            make.height.equalTo(600)
        }
        descriptionLabel.snp.makeConstraints { (make) in
            make.bottomMargin.equalToSuperview()
            make.left.equalTo(snp.left).inset(20)
            make.right.equalTo(snp.right).inset(20)
            make.height.equalTo(60)
        }
    }

}
