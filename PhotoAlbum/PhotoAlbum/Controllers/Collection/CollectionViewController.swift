//
//  CollectionViewController.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 2/7/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    var photosCollectionView: CollectionView!
    var photosCollectionViewModel: CollectionViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        CustomNavigationController.shared.navigationBar.isTranslucent = false
        photosCollectionView = {
            let view = CollectionView(frame: CGRect.zero)
            view.collectionView.dataSource = self
            view.collectionView.delegate = self
            view.collectionView.register(PhotoViewCell.self, forCellWithReuseIdentifier: "cellid")
            view.collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
            return view
        }()
        photosCollectionViewModel = CollectionViewModel()
        view.addSubview(photosCollectionView)
        
        photosCollectionView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        photosCollectionViewModel.loadPhotos { (error) in
            if !error{
                self.photosCollectionViewModel.items.removeAll()
                self.photosCollectionViewModel.items = APIHelper.shared.items
                self.photosCollectionView.collectionView.reloadData()
            }
        }
    }
    
}
extension CollectionViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosCollectionViewModel.numberOfItemsInSection(section: section)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return photosCollectionViewModel.totalSections()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath)
        return cell
    }
    
    
}
