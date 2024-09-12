//
//  PhotoResultResponse.swift
//  Snapsea
//
//  Created by Irina Deeva on 11/09/24.
//

import Foundation

struct PhotoResultResponse: Decodable {
    let id: String
    let createdAt: String?
    let description: String?
    let urls: UrlsResultResponse
    let user: UserResultResponse

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case description = "description"
        case urls = "urls"
        case user = "user"
     }
}
