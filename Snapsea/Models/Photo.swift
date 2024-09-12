//
//  Image.swift
//  Snapsea
//
//  Created by Irina Deeva on 11/09/24.
//

import Foundation


struct Photo {
    let id: String
    let width: Int
    let height: Int
    let smallImageURL: String
    let thumbImageURL: String
    let largeImageURL: String
    let description: String?
    let author: String?
    let likes: Int?
    let createdDate: String?

    init(from photo: PhotoResultResponse) {
        self.id = photo.id
        self.width = photo.width
        self.height = photo.height
        self.smallImageURL = photo.urls.small.absoluteString
        self.thumbImageURL = photo.urls.thumb.absoluteString
        self.largeImageURL = photo.urls.full.absoluteString
        self.description = photo.description
        self.likes = photo.likes
        self.createdDate = photo.createdAt
        self.author = photo.user.name
    }
}
