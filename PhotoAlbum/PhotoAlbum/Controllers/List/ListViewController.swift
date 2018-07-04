//
//  ListViewController.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 4/7/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    var photosListView: ListView!
    var photosListViewModel: ListViewModel!
    var cellShape: Shape! = Shape.Square
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        CustomNavigationController.shared.loadStyleListView(title: "List")
        CustomNavigationController.shared.switchDelegate = self
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
            view.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "header")
            return view
        }()
        photosListViewModel = ListViewModel()
        view.addSubview(photosListView)
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
extension ListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return photosListViewModel.getTotalSections()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid") as! AlbumCell
        cell.shape = cellShape
        cell.photosListViewModel = photosListViewModel
        cell.sectionToShow = indexPath.section
        for i in cell.collectionView.visibleCells{
            (i as! PhotoViewCell).setupCell(with: cellShape)
        }
        registerForPreviewing(with: self, sourceView: cell)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect.init(x: 0, y: 0, width: view.frame.width, height: 40))
        header.backgroundColor = UIColor.white
        let titleLabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: 300.0, height: 40))
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.backgroundColor = UIColor.white
        titleLabel.text = "Album \(section+1)"
        header.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.right.height.equalToSuperview()
            make.left.equalToSuperview().inset(20)
        }
        return header
    }
}
extension ListViewController: UIViewControllerPreviewingDelegate{
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let albumcell = previewingContext.sourceView as? AlbumCell else{
            return nil
        }
        guard let item = albumcell.collectionView.indexPathForItem(at: location) else {
            return nil
        }
        let indexPath = IndexPath.init(item: item.item, section: albumcell.sectionToShow)
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
        }
        CustomNavigationController.shared.pushViewController(viewControllerToCommit, animated: true)
    }
}
extension ListViewController: UISwitchDelegate{
    func switchStateChanged(value: Bool) {
        if value{
            cellShape = Shape.Circle
        }else{
            cellShape = Shape.Square
        }
        photosListView.tableView.reloadData()
    }
}
