import Foundation

public struct APIRequest {
    let url: String
    let method: HTTPMethod
    let headers: [String: String]?
    let body: Encodable?
    
    init(url: String, method: HTTPMethod, headers: [String: String]? = nil, body: Encodable? = nil) {
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
    }
}
