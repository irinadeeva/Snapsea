//
//  Image.swift
//  Snapsea
//
//  Created by Irina Deeva on 11/09/24.
//

import Foundation


struct Photo {
    let id: String
    let description: String?
    let smallImageURL: URL
    let thumbImageURL: String
    let largeImageURL: String

    init(from photo: PhotoResultResponse) {
        self.id = photo.id
        self.description = photo.description
        self.smallImageURL = photo.urls.small
        self.thumbImageURL = photo.urls.thumb.absoluteString
        self.largeImageURL = photo.urls.full.absoluteString
    }
}
