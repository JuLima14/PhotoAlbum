//
//  PhotoDetailView.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 21/6/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit

class PhotoDetailView: UIView, ViewUpdatable {
    
    let imageView: UIImageView = {
        let view = UIImageView(frame: CGRect.zero)
        view.contentMode = .scaleAspectFit
        view.backgroundColor = Stylesheet.shared.white
        return view
    }()
    
    let descriptionLabel: UILabel = {
        let view = UILabel(frame: CGRect.zero)
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.textColor = Stylesheet.shared.black
        view.numberOfLines = 0
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
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Stylesheet.shared.white
        addSubview(imageView)
        addSubview(descriptionLabel)
        
    }
    
    func setupConstraints() {
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
    
    func update(item: Any) {
        guard let item = item as? PhotoDetailModelView else { return }
        
        imageView.sd_setImage(with: URL(string: item.item.url)!, placeholderImage: nil, options: .progressiveDownload, progress:
            { (receivedSize, expectedSize, targetURL) in
                //set percentage load
        }) { [weak self] (fetchedImage, error, cacheType, url) in
            
            if error != nil {
                print("Error loading Image from URL: \(String(describing: url!))\n\(String(describing: error?.localizedDescription))")
            }
            
            if (url?.absoluteString)! == item.item.url {
                self?.imageView.image = fetchedImage
            }
        }
        descriptionLabel.text = item.item.title
    }
}
