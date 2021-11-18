import Foundation

public protocol Repository {
    associatedtype RepositoryType
    func fetch(_ endpoint: EndPoint, completion: @escaping (Result<RepositoryType, Error>) -> Void)
    func cancel(_ endpoint: EndPoint, urlCache: [EndPoint: Bool])
}
