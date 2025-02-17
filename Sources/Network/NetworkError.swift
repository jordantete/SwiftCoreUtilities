import Foundation

enum NetworkError: Error {
    case invalidURL
    case serverError(Int)
    case noResponse
    case encodingFailed
    case decodingFailed
    case notConnected
    case timedOut
    case networkConnectionLost
    case invalidRequest
    case unknown(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .serverError(let code):
            return "Server returned status code \(code)."
        case .noResponse:
            return "No response from server."
        case .encodingFailed:
            return "Failed to encode request body."
        case .decodingFailed:
            return "Failed to decode response."
        case .notConnected:
            return "No internet connection."
        case .timedOut:
            return "The request timed out."
        case .networkConnectionLost:
            return "Network connection was lost."
        case .invalidRequest:
            return "Invalid request."
        case .unknown(let error):
            return "Unknown network error: \(error.localizedDescription)"
        }
    }
    
    static func from(_ error: Error) -> NetworkError {
        let nsError = error as NSError

        if nsError.domain == NSURLErrorDomain {
            switch nsError.code {
            case NSURLErrorNotConnectedToInternet:
                return .notConnected
            case NSURLErrorTimedOut:
                return .timedOut
            case NSURLErrorNetworkConnectionLost:
                return .networkConnectionLost
            case NSURLErrorBadURL, NSURLErrorUnsupportedURL, NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost:
                return .invalidRequest
            default:
                return .unknown(error)
            }
        }
        return .unknown(error)
    }
}
