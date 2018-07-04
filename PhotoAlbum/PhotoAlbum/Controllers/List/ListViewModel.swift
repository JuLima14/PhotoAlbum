//
//  ListViewModel.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 4/7/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit

class ListViewModel {
    
    var items = [Int:[Photo]]()
    
    func getTotalNumberInSection(section: Int) -> Int{
        if APIHelper.shared.items[section+1] != nil{
            return (APIHelper.shared.items[section+1]?.count)!
        }else{
            return 0
        }
    }
    func getTotalSections() -> Int{
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
