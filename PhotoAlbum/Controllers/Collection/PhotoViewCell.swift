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
    case Default
    case Circle
    case Square
}
class PhotoViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView(frame: CGRect.zero)
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = Stylesheet.shared.middleGray
        layer.masksToBounds = true
        addSubview(imageView)
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func update(with: Shape){
        UIView.animate(withDuration: 0.4) {
            switch with {
                case .Square, .Default:
                    self.layer.cornerRadius = 5
                case .Circle:
                    self.layer.cornerRadius = self.frame.width / 2
            }
        }
    }
    
    func loadPhoto(photo: Photo,type: PhotoNames){
        
        let stringUrl = type == .thumbnailUrl ? photo.thumbnailUrl : photo.url
        
        imageView.sd_setImage(with: URL(string: stringUrl)!, placeholderImage: nil) { [weak self] (fetchedImage, error, cacheType, url) in
            if error != nil {
                print("Error loading Image from URL: \(String(describing: url))\n\(String(describing: error?.localizedDescription))")
            }
            self?.imageView.image = fetchedImage!
        }
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
