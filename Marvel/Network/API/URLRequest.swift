import Foundation
import OSLog

public protocol Request {
    init(
        endpoint: EndPoint,
        httpMethod: HTTPMethod,
        cachePolicy: URLRequest.CachePolicy,
        timeoutInterval: TimeInterval
    )
}

extension URLRequest: Request {
    public init(
        endpoint: EndPoint,
        httpMethod: HTTPMethod = .get,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = .infinity
    ) {
        guard let url = endpoint.path else {
            Logger.log.error("URL Error - Un-available to get the valid URL")
            preconditionFailure("Invalid URL used to create URL instance")
        }
        
        Logger.log.error("URL: \(url), CachePolicy: \(cachePolicy.rawValue), timeoutInterval: \(timeoutInterval)")
        self.init(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        self.httpMethod = httpMethod.rawValue
    }
}

