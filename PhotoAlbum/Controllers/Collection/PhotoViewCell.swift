//
//  PhotoViewCell.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 20/6/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//
import UIKit
import SDWebImage

enum Shape: String{
    case Circle = "circle"
    case Square = "square"
}
class PhotoViewCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    
    func setupCell(with: Shape){
        backgroundColor = UIColor.white
        layer.masksToBounds = true
        UIView.animate(withDuration: 0.4) {
            switch with {
            case .Square:
                self.layer.cornerRadius = 5
            case .Circle:
                self.layer.cornerRadius = self.frame.width / 2
            }
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
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
