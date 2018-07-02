//
//  SectionHeader.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 2/7/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.white
        titleLabel = {
            let view = UILabel(frame: .zero)
            view.textAlignment = .left
            view.font = UIFont.boldSystemFont(ofSize: 30)
            return view
        }()
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).inset(20)
            make.top.right.bottom.equalToSuperview()
        }
    }
    func setHeader(name: String){
        titleLabel.text = name
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
