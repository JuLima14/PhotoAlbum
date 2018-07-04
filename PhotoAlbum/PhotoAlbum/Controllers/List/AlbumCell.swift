//
//  AlbumCell.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 4/7/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {
    
    var collectionView: UICollectionView!
    var photosListViewModel: ListViewModel!
    var sectionToShow: Int! = 0
    var shape: Shape! = Shape.Square
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collectionView = {
            let cellLayout = UICollectionViewFlowLayout()
            cellLayout.scrollDirection = .horizontal
            let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: cellLayout)
            view.register(PhotoViewCell.self, forCellWithReuseIdentifier: "cellid")
            view.backgroundColor = UIColor.white
            view.showsHorizontalScrollIndicator = false
            view.delegate = self
            view.dataSource = self
            return view
        }()
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        collectionView.reloadData()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
}
extension AlbumCell: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosListViewModel.getTotalNumberInSection(section: section)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! PhotoViewCell
        cell.setupCell(with: shape)
        guard let list = photosListViewModel.items[self.sectionToShow+1]
            else{ return cell }
        cell.loadPhoto(photo: list[indexPath.item],type: PhotoNames.thumbnailUrl, completionHandler: {_ in})
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let list = self.photosListViewModel.items[self.sectionToShow+1]
            else{ return }
            let pdc = PhotoDetailController()
            pdc.setupView(photo: PhotoDetailModelView(item: list[indexPath.item]))
            CustomNavigationController.shared.pushViewController(pdc, animated: true)
    }
}
extension AlbumCell: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let hardCodedPadding: CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        return CGSize(width: itemWidth, height: itemWidth)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
}

