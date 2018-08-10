//
//  CollectionViewController.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 20/6/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    
    var photosCollectionView: CollectionView!
    var photosCollectionViewModel: CollectionViewModel!
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true
        CustomNavigationController.shared.loadStyleCollectionView(title: "Album")
    }

    func setupView(){
        CustomNavigationController.shared.navigationBar.isTranslucent = false
        CustomNavigationController.shared.tabBarItem.badgeColor = Stylesheet.shared.red
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        photosCollectionView = {
            let view = CollectionView(frame: CGRect.zero)
            view.collectionView.dataSource = self
            view.collectionView.delegate = self
            view.collectionView.register(PhotoViewCell.self, forCellWithReuseIdentifier: "cellid")
            view.collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
            view.collectionView.backgroundColor = Stylesheet.shared.middleGray
            return view
        }()
        photosCollectionViewModel = CollectionViewModel()
        
        view.addSubview(photosCollectionView)
        view.addSubview(activityIndicator)
       
        registerForPreviewing(with: self, sourceView: photosCollectionView.collectionView)
        
        photosCollectionView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        activityIndicator.startAnimating()
        photosCollectionViewModel.loadPhotos { (error) in
            if !error{
                self.photosCollectionViewModel.items.removeAll()
                self.photosCollectionViewModel.items = APIHelper.shared.items
                self.photosCollectionView.collectionView.reloadData()
            }
            self.activityIndicator.stopAnimating()
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as? PhotoViewCell
            else{ return UICollectionViewCell() }
        
        cell.setupCell(with: .Square)
        
        guard let list = photosCollectionViewModel.items[indexPath.section+1]
            else{ return cell }
        
        cell.loadPhoto(photo: list[indexPath.item],type: PhotoNames.thumbnailUrl, completionHandler: {_ in})
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pdc = PhotoDetailController()
        if let values = self.photosCollectionViewModel.items[indexPath.section+1]{
            pdc.setupView(photo: PhotoDetailModelView(item: values[indexPath.item]))
        }
        CustomNavigationController.shared.pushViewController(pdc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // Dequeue Reusable Supplementary View
        guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as? SectionHeader
            else { fatalError("Unable to Dequeue Reusable Supplementary View") }
        // Configure Supplementary View
        supplementaryView.setHeader(name: "Album \(indexPath.section+1)")
        supplementaryView.titleLabel.textColor = Stylesheet.shared.white
        supplementaryView.backgroundColor = Stylesheet.shared.darkGray
        return supplementaryView
        
    }
    
}
extension CollectionViewController:  UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 60)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 10, 10, 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = photosCollectionView.bounds.width / 2 - 15
        return CGSize(width: width, height: width)
    }
    
}

extension CollectionViewController: UIViewControllerPreviewingDelegate{
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = photosCollectionView.collectionView.indexPathForItem(at: location) else {
            return nil
        }
        let pdc = PhotoDetailController()
        if let values = photosCollectionViewModel.items[indexPath.section+1]{
            pdc.setupView(photo: PhotoDetailModelView(item: values[indexPath.item]))
            pdc.prepareViewForPreviewing()
        }
        return pdc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        UIView.animate(withDuration: 0.5) {
            viewControllerToCommit.view.layer.masksToBounds = false
            if viewControllerToCommit.isKind(of: PhotoDetailController.self){
                (viewControllerToCommit as! PhotoDetailController).isHiddenDescriptionLabel = false
            }
            CustomNavigationController.shared.pushViewController(viewControllerToCommit, animated: false)
        }
    }
}
