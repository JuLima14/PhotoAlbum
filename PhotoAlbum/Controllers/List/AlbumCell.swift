//
//  AlbumCell.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 24/6/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit

protocol AlbumCellDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    func collectionView(numberOfItemsInSection section: Int) -> Int
}

class AlbumCell: UITableViewCell {
    
    let collectionView: AsyncCollectionView = {
        let cellLayout = UICollectionViewFlowLayout()
        cellLayout.scrollDirection = .horizontal
        let view = AsyncCollectionView(frame: CGRect.zero, collectionViewLayout: cellLayout)
        view.register(PhotoViewCell.self, forCellWithReuseIdentifier: "cellid")
        view.backgroundColor = Stylesheet.shared.white
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    var photosListViewModel: ListViewModel?
    var sectionToShow: Int = 0
    var delegate: AlbumCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setupConstraints()
    }
    
    func setup() {
        addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.reloadData()

    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
}
extension AlbumCell: UISwitchDelegate{
    func switchStateChanged(value: Bool) {
        photosListViewModel?.shapeCell = value ? Shape.Circle : Shape.Square
        collectionView.reloadData()
    }
}
extension AlbumCell: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let numberOfItems = delegate?.collectionView(numberOfItemsInSection: section) else { return 0 }
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as? PhotoViewCell, let list = photosListViewModel?.items[sectionToShow + 1] else { return UICollectionViewCell() }
        cell.update(with: photosListViewModel?.shapeCell ?? .Default)
        cell.loadPhoto(photo: list[indexPath.item],type: .thumbnailUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionView(collectionView, didSelectItemAt: IndexPath(item: indexPath.item, section: sectionToShow ))
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
