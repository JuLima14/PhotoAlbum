//
//  ListView.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 24/6/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit

class ListView: UIView{
    
    var tableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPhotosCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhotosCollectionView(){
        translatesAutoresizingMaskIntoConstraints = false
        tableView = {
            let view = UITableView(frame: CGRect.zero)
            view.backgroundColor = Stylesheet.shared.white
            return view
        }()
        addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
}
