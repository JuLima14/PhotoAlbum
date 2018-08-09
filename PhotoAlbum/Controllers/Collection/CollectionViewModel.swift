//
//  CollectionViewModel.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 21/6/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

class CollectionViewModel {
    
    var items = [Int:[Photo]]()
    
    func numberOfItemsInSection(section: Int) -> Int{
        if APIHelper.shared.items[section+1] != nil{
            return (APIHelper.shared.items[section+1]?.count)!
        }else{
            return 0
        }
    }
    func totalSections() -> Int{
        if APIHelper.shared.items.count == 0{
            return 1
        }else{
            return APIHelper.shared.items.count
        }
    }
    func loadPhotos(completionHandler: @escaping((Bool)->Void)){
        APIHelper.shared.request_photos { (response) in
            completionHandler(response)
        }
    }
}
