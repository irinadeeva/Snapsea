//
//  Image.swift
//  Snapsea
//
//  Created by Irina Deeva on 11/09/24.
//

import Foundation


struct Photo {
    let id: String
//    let width: Int
//    let height: Int
    let smallImageURL: String
    let thumbImageURL: String
//    let largeImageURL: String
    let description: String
    let author: String
//    let likes: Int?
//    let createdDate: String?

//    init(from photo: PhotoResultResponse) {
//        guard let description = photo.description,
//              let author = photo.user.name,
//              let small = photo.urls.small,
//              let thumb = photo.urls.thumb
//
//        self.id = photo.id
////        self.width = photo.width
////        self.height = photo.height
//        self.smallImageURL = small.absoluteString
//        self.thumbImageURL = thumb.absoluteString
////        self.largeImageURL = photo.urls.full.absoluteString
//        self.description = description
////        self.likes = photo.likes
////        self.createdDate = photo.createdAt
//        self.author = author
//    }

    init(id: String, smallImageURL: String, thumbImageURL: String, description: String, author: String) {
        self.id = id
        self.smallImageURL = smallImageURL
        self.thumbImageURL = thumbImageURL
        self.description = description
        self.author = author
    }
}
