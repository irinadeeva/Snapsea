//
//  UrlsResultResponse.swift
//  Snapsea
//
//  Created by Irina Deeva on 11/09/24.
//

import Foundation

struct UrlsResultResponse: Decodable {
    let raw: URL
    let full: URL
    let regular: URL
    let small: URL?
    let thumb: URL?
}
