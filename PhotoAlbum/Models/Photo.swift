//
//  Photo.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 20/6/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit

struct Photo: Decodable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}

enum PhotoNames : String{
    case albumId = "albumId"
    case id = "id"
    case title = "title"
    case url = "url"
    case thumbnailUrl = "thumbnailUrl"
}
