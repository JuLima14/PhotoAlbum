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
extension CollectionViewController : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosCollectionViewModel.numberOfItemsInSection(section: section)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return photosCollectionViewModel.totalSections()
    }
    //indexPath starts in 0 and ids of photos starts in 1 so indexPath.item + 1
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! PhotoViewCell
        cell.setupCell(with: .Collection)
        if photosCollectionViewModel.items[indexPath.section+1] != nil{
            let list = photosCollectionViewModel.items[indexPath.section+1]
            cell.loadPhoto(photo: (list?[indexPath.item])!,type: PhotoNames.thumbnailUrl, completionHandler: {_ in})
        }else{
            print("Fail when loading a cell IndexPath:(Section: \(indexPath.section+1), Item: \(indexPath.item)")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // Dequeue Reusable Supplementary View
        if let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as? SectionHeader {
            // Configure Supplementary View
            supplementaryView.setHeader(name: "Album \(indexPath.section+1)")
            return supplementaryView
        }
        fatalError("Unable to Dequeue Reusable Supplementary View")
    }

}
extension CollectionViewController:  UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 70)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = photosCollectionView.bounds.width / 2 - 15
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
}
