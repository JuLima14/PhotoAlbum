//
//  CollectionView.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 2/7/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit
import SnapKit

class CollectionView: UIView {

    var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPhotosCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhotosCollectionView(){
        translatesAutoresizingMaskIntoConstraints = false
        collectionView = {
            let cellLayout = StickyHeadersCollectionViewFlowLayout()
            let view = UICollectionView(frame: bounds, collectionViewLayout: cellLayout)
            view.backgroundColor = UIColor.white
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
}
