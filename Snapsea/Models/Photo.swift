//
//  Image.swift
//  Snapsea
//
//  Created by Irina Deeva on 11/09/24.
//

import Foundation


struct Photo {
    let id: String
    let smallImageURL: String
    let thumbImageURL: String
    let description: String
    let author: String
    let createdDate: String?

    init(id: String, 
         smallImageURL: String,
         thumbImageURL: String,
         description: String,
         author: String,
         createdDate: String) {
        self.id = id
        self.smallImageURL = smallImageURL
        self.thumbImageURL = thumbImageURL
        self.description = description
        self.author = author
        self.createdDate = createdDate
    }
}
