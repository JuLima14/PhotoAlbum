//
//  APIHelper.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 2/7/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum OptionUrl : String {
    case Url = "url"
    case ThumbnailUrl = "thumbnailUrl"
}

class APIHelper {
    
    static let shared = APIHelper()
    private var url = "https://jsonplaceholder.typicode.com/photos"
    var items = [Int:[Photo]]()
    
    func request_photos(completionHandler: @escaping((Bool)->Void) ){
        
        if items.count == 0{
            Alamofire.request(url).responseJSON { (response) in
                guard response.result.error == nil else {
                    completionHandler(true)
                    return
                }
                guard let value = response.result.value, let jsonArray = JSON(value).array else {
                    completionHandler(true)
                    return
                }
                jsonArray.forEach({ (json) in
                    guard let albumId = json[PhotoNames.albumId.rawValue].int,
                        let id = json[PhotoNames.id.rawValue].int,
                        let title = json[PhotoNames.title.rawValue].string,
                        let thumbnailUrl = json[PhotoNames.thumbnailUrl.rawValue].string,
                        let url = json[PhotoNames.url.rawValue].string else{
                            return
                    }
                    if self.items[albumId] == nil{
                        self.items[albumId] = [Photo]()
                    }
                    self.items[albumId]!.append(Photo(albumId: albumId, id: id, title: title, url: url, thumbnailUrl: thumbnailUrl))
                })
                completionHandler(false)
            }
        }else{
            completionHandler(false)
        }
    }
}
