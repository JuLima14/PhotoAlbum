//
//  AsyncCollectionView.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 16/2/19.
//  Copyright © 2019 Julian Lima. All rights reserved.
//

import UIKit

final class AsyncCollectionView: UICollectionView {
    
    private var reloadDataCompletionBlock: (() -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        reloadDataCompletionBlock?()
        reloadDataCompletionBlock = nil
    }
    
    
    func reloadDataWithCompletion(_ completion: @escaping () -> Void) {
        reloadDataCompletionBlock = completion
        super.reloadData()
    }
    
}
