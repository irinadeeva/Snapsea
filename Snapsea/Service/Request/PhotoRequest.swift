//
//  ImagesRequest.swift
//  Snapsea
//
//  Created by Irina Deeva on 11/09/24.
//

import Foundation

struct PhotoRequest: NetworkRequest {

    var endpoint = "\(RequestConstants.baseURL)/search/photos/"

    var httpMethod: HttpMethod { .get }

    var queryItems: [URLQueryItem] {
        [URLQueryItem(name: "client_id", value: RequestConstants.token),
         URLQueryItem(name: "query", value: text)]
    }

    var text: String

}
