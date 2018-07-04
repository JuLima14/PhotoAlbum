//
//  PhotoViewCell.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 2/7/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit
import SDWebImage

enum Shape: String{
    case List = "list"
    case Collection = "collection"
}
class PhotoViewCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    
    func setupCell(with: Shape){
        
        backgroundColor = UIColor.white
        layer.masksToBounds = true
        
        switch with {
        case .Collection:
            layer.cornerRadius = 5
        case .List:
            layer.cornerRadius = frame.width / 2
        }
        
        imageView = {
            let view = UIImageView(frame: CGRect.zero)
            view.isUserInteractionEnabled = true
            view.translatesAutoresizingMaskIntoConstraints = false
            view.contentMode = .scaleAspectFill
            return view
        }()
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.right.left.top.bottom.equalToSuperview()
        }
    }
    
    func loadPhoto(photo: Photo,type: PhotoNames!, completionHandler: @escaping (UIImage)->()){
        var selectedType: String!
        if type == .thumbnailUrl{
            selectedType = photo.thumbnailUrl
        }else{
            selectedType = photo.url
        }
        imageView.sd_setImage(with: URL(string: selectedType)!, placeholderImage: nil) { (fetchedImage, error, cacheType, url) in
            if error != nil {
                print("Error loading Image from URL: \(String(describing: url))\n\(String(describing: error?.localizedDescription))")
            }
            self.imageView.image = fetchedImage!
            completionHandler(fetchedImage!)
        }
    }
}
