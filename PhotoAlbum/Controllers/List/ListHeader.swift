//
//  ListHeader.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 25/6/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit

class ListHeader: UITableViewHeaderFooterView {
    
    var titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
