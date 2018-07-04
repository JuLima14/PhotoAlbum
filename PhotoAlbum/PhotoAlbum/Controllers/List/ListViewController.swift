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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
        cell.photosListViewModel = photosListViewModel
        cell.sectionToShow = indexPath.section
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        header?.contentView.backgroundColor = UIColor.white
        header?.textLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        header?.textLabel?.text = "Album \(section+1)"
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
}

