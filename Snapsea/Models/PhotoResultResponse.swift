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
//    let createdAtString: String?
    let description: String?
    let urls: UrlsResultResponse
}
