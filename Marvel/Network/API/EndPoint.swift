import Foundation

enum EndPoint: Hashable {
    case characters(limit: Int, offset: Int)
    case image(url: String)
}

extension EndPoint {
    public var base: String { "https://gateway.marvel.com/v1/public/" }
    
    var path: URL? {
        let baseURL = URL(string: base)
        
        switch self {
        case .characters(let limit, let offset):
            return path(url: baseURL?.appendingPathComponent("characters"))?.appending([
                    URLQueryItem(name: "limit", value: String(describing: limit)),
                    URLQueryItem(name: "offset", value: String(describing: offset))
                ])
        case .image(let url):
            return URL(string: url)
        }
    }
    
    private func path(url: URL?) -> URL? {
        let timestamp = Date.timeIntervalSinceReferenceDate
        return url?.appending([
            URLQueryItem(name: "ts", value: String(describing: timestamp)),
            URLQueryItem(name: "apikey", value: Person.aravind.publicKey),
            URLQueryItem(name: "hash", value: Security.md5Hash(timeStamp: timestamp))
        ])
    }
}
