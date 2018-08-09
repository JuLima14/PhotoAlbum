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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        CustomNavigationController.shared.loadStyleListView(title: "List")
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    func setupView(){
        photosListView = {
            let view = ListView(frame: CGRect.zero)
            view.tableView.dataSource = self
            view.tableView.delegate = self
            view.tableView.register(AlbumCell.self, forCellReuseIdentifier: "cellid")
            view.tableView.register(ListHeader.self, forHeaderFooterViewReuseIdentifier: "header")
            return view
        }()
        photosListViewModel = ListViewModel()
        view.addSubview(photosListView)
        registerForPreviewing(with: self, sourceView: photosListView.tableView)
        photosListView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        photosListViewModel.loadPhotos { (error) in
            if !error{
                self.photosListViewModel.items.removeAll()
                self.photosListViewModel.items = APIHelper.shared.items
                self.photosListView.tableView.reloadData()
            }
        }
    }
}
extension ListViewController: UIViewControllerPreviewingDelegate{
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexCollection = photosListView.tableView.indexPathForRow(at: location) else {
            return nil
        }
        let collectionView = (photosListView.tableView.cellForRow(at: indexCollection) as! AlbumCell).collectionView
        
        guard let indexPath =  collectionView?.indexPathForItem(at: location) else {
            return nil
        }
        
        let pdc = PhotoDetailController()
        if let values = photosListViewModel.items[indexPath.section+1]{
            pdc.setupView(photo: PhotoDetailModelView(item: values[indexPath.item]))
        }
        return pdc
    }
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        photosListViewModel.lastAlbumSelected = IndexPath(item: -1, section: -1)
        CustomNavigationController.shared.pushViewController(viewControllerToCommit, animated: true)
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
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        header?.contentView.backgroundColor = Stylesheet.shared.white
        header?.textLabel?.text = "Album \(section+1)"
        header?.textLabel?.textColor = Stylesheet.shared.black
        header?.textLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

}


