//
//  ViewInitializable.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 16/2/19.
//  Copyright © 2019 Julian Lima. All rights reserved.
//

import UIKit


protocol ViewInitializable where Self: UIView {
    func setup()
    func setupConstraints()
}

protocol ViewUpdatable: ViewInitializable {
    func update(item: Any)
}
