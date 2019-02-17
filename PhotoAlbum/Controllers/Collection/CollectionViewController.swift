//
//  CollectionViewController.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 20/6/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    var photosCollectionView: CollectionView = {
        let view = CollectionView(frame: CGRect.zero)
        view.collectionView.register(PhotoViewCell.self, forCellWithReuseIdentifier: "cellid")
        view.collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        view.collectionView.backgroundColor = Stylesheet.shared.middleGray
        return view
    }()
    
    var photosCollectionViewModel = CollectionViewModel()
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true
//        self.loadStyleNavigationBar(title: "Album")
    }
    func loadStyleNavigationBar(title: String){
        navigationController?.navigationBar.pushItem(UINavigationItem(title: title), animated: true)
        navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
        navigationController?.navigationBar.barTintColor = Stylesheet.shared.red
        navigationController?.navigationBar.isTranslucent = false
    }
    func setup(){
        view.backgroundColor = Stylesheet.shared.middleGray
        
        photosCollectionView.collectionView.dataSource = self
        photosCollectionView.collectionView.delegate = self
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        
        view.addSubview(photosCollectionView)
        view.addSubview(activityIndicator)
       
        registerForPreviewing(with: self, sourceView: photosCollectionView.collectionView)
        
        activityIndicator.startAnimating()
        
        photosCollectionViewModel.loadPhotos { [weak self] (error) in
            
            guard let strongSelf = self else { return }
            
            if !error{
                strongSelf.photosCollectionViewModel.items.removeAll()
                strongSelf.photosCollectionViewModel.items = APIHelper.shared.items
                strongSelf.photosCollectionView.collectionView.reloadData()
                strongSelf.activityIndicator.stopAnimating()
            }
        }
    }
    
    func setupConstraints() {
        photosCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}
extension CollectionViewController : UISwitchDelegate{
    func switchStateChanged(value: Bool) {
        if value{
            self.photosCollectionViewModel.quantityOfColumns = 1
        }else{
            self.photosCollectionViewModel.quantityOfColumns = 2
        }
        UIView.animate(withDuration: 1) {
            let layout = UICollectionViewFlowLayout()
            let quantity: CGFloat = self.photosCollectionViewModel.quantityOfColumns
            let width = self.photosCollectionView.bounds.width / quantity - 15
            layout.itemSize = CGSize(width: width, height: width)
            self.photosCollectionView.collectionView.setCollectionViewLayout(layout, animated: true)
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
        
        cell.update(with: .Square)
        
        guard let list = photosCollectionViewModel.items[indexPath.section+1]
            else{ return cell }
        
        cell.loadPhoto(photo: list[indexPath.item],type: PhotoNames.thumbnailUrl, completionHandler: {_ in})
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pdc = PhotoDetailController()
        if let values = self.photosCollectionViewModel.items[indexPath.section+1]{
            pdc.setup(photo: PhotoDetailModelView(item: values[indexPath.item]))
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
        let quantity: CGFloat = self.photosCollectionViewModel.quantityOfColumns
        let width = self.photosCollectionView.bounds.width / quantity - 15
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
            pdc.setup(photo: PhotoDetailModelView(item: values[indexPath.item]))
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
