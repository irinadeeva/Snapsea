//
//  PhotoResultResponse.swift
//  Snapsea
//
//  Created by Irina Deeva on 11/09/24.
//

import Foundation

struct SearchedPhotoResultResponse: Decodable {
    let total: Int
    let total_pages: Int
    let results: [PhotoResultResponse]
}
