//
//  TableViewController.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 20/6/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit


class ListViewController: UIViewController {

    var photosListView: ListView!
    var photosListViewModel: ListViewModel!
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        CustomNavigationController.shared.loadStyleListView(title: "List")
    }
    func setupView(){
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        photosListView = {
            let view = ListView(frame: CGRect.zero)
            view.tableView.dataSource = self
            view.tableView.delegate = self
            view.tableView.register(AlbumCell.self, forCellReuseIdentifier: "cellid")
            view.tableView.register(ListHeader.self, forHeaderFooterViewReuseIdentifier: "header")
            view.tableView.backgroundColor = Stylesheet.shared.darkGray
            return view
        }()
        photosListViewModel = ListViewModel()
        view.addSubview(photosListView)
        view.addSubview(activityIndicator)
        
        registerForPreviewing(with: self, sourceView: photosListView.tableView)
        
        photosListView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        activityIndicator.startAnimating()
        photosListViewModel.loadPhotos { (error) in
            if !error{
                self.photosListViewModel.items.removeAll()
                self.photosListViewModel.items = APIHelper.shared.items
                self.photosListView.tableView.reloadData()
            }
            self.activityIndicator.stopAnimating()
        }
    }
}
extension ListViewController: UIViewControllerPreviewingDelegate{
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexCollection = photosListView.tableView.indexPathForRow(at: location) else {
            return nil
        }
        
        guard let albumCell = photosListView.tableView.cellForRow(at: indexCollection) as? AlbumCell else {
            return nil
        }
        let locationCollection = photosListView.tableView.convert(location, to: albumCell.collectionView)
        guard let indexItem = albumCell.collectionView?.indexPathForItem(at: locationCollection) else {
            return nil
        }
        
        let indexPath = IndexPath(item: indexItem.item, section: indexCollection.section)
        let pdc = PhotoDetailController()
        if let values = photosListViewModel.items[indexPath.section+1]{
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
extension ListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return photosListViewModel.getTotalSections()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid") as! AlbumCell
        cell.photosListViewModel = photosListViewModel
        cell.sectionToShow = indexPath.section
        cell.collectionView.backgroundColor = Stylesheet.shared.darkGray
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        header?.contentView.backgroundColor = Stylesheet.shared.darkGray
        header?.textLabel?.text = "Album \(section+1)"
        header?.textLabel?.textColor = Stylesheet.shared.white
        header?.textLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

}


