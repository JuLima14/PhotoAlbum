//
//  ListView.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 24/6/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit

class ListView: UIView{
    
    let tableView: AsyncTableView = {
        let view = AsyncTableView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Stylesheet.shared.white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPhotosCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhotosCollectionView(){
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
