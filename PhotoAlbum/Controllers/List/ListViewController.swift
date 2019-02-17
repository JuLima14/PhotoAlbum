//
//  TableViewController.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 20/6/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit


class ListViewController: UIViewController {

    var photosListView: ListView = {
        let view = ListView(frame: CGRect.zero)
        view.tableView.register(AlbumCell.self, forCellReuseIdentifier: "cellid")
        view.tableView.register(ListHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        view.tableView.backgroundColor = Stylesheet.shared.darkGray
        return view
    }()
    
    var photosListViewModel: ListViewModel = ListViewModel()
    
    var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.activityIndicatorViewStyle = .gray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        self.loadStyleNavigationBar(title: "List")
    }
    
    func loadStyleNavigationBar(title: String){
        navigationController?.navigationBar.topItem?.title = title
        navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
        navigationController?.navigationBar.barTintColor = Stylesheet.shared.red
    }
    
    func setup(){
        view.addSubview(photosListView)
        view.addSubview(activityIndicator)
        
        photosListView.tableView.dataSource = self
        photosListView.tableView.delegate = self
        
        registerForPreviewing(with: self, sourceView: photosListView.tableView)
        
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
    
    func setupConstraints() {
        photosListView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
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
        guard let indexItem = albumCell.collectionView.indexPathForItem(at: locationCollection) else {
            return nil
        }
        
        let indexPath = IndexPath(item: indexItem.item, section: indexCollection.section)
        let pdc = PhotoDetailController()
        if let values = photosListViewModel.items[indexPath.section+1]{
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
            
            self.navigationController?.pushViewController(viewControllerToCommit, animated: false)
            self.navigationController?.hidesBarsOnSwipe = false
            if (self.navigationController?.isNavigationBarHidden)! {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
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


