//
//  Photo.swift
//  PhotoAlbum
//
//  Created by Julian Lima on 2/7/18.
//  Copyright © 2018 Julian Lima. All rights reserved.
//

import UIKit

struct Photo {
    var albumId: Int!
    var id: Int!
    var title: String!
    var url: String!
    var thumbnailUrl: String!
}

enum PhotoNames : String{
    case albumId = "albumId"
    case id = "id"
    case title = "title"
    case url = "url"
    case thumbnailUrl = "thumbnailUrl"
}
