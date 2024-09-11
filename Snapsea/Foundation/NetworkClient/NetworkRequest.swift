import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkRequest {
    var endpoint: String { get }
    var httpMethod: HttpMethod { get }
    var queryItems: [URLQueryItem] { get }
}
