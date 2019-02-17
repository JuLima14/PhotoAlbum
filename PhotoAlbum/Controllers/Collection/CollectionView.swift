//
//  CollectionView.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 20/6/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit
import SnapKit

class CollectionView: UIView {
    
    var collectionView: AsyncCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.sectionHeadersPinToVisibleBounds = true
        layout.sectionInset.top = 10
        let view = AsyncCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = Stylesheet.shared.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstrainst()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
    }
    
    private func setupConstrainst() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
