//
//  PhotoResultResponse.swift
//  Snapsea
//
//  Created by Irina Deeva on 11/09/24.
//

import Foundation

struct PhotoResultResponse: Decodable {
    let id: String
//    let width: Int
//    let height: Int
//    let likes: Int?
    let createdAt: String?
    let description: String?
    let urls: UrlsResultResponse
    let user: UserResultResponse

    private enum CodingKeys: String, CodingKey {
        case id = "id"
//        case width = "width"
//        case height = "height"
        case createdAt = "created_at"
        case description = "description"
        case urls = "urls"
//        case likes = "likes"
        case user = "user"
     }
}
