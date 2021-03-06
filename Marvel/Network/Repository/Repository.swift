import Foundation
import UIKit

protocol Repository {
    associatedtype RepositoryType
    func fetch(_ endpoint: EndPoint, completion: @escaping (Result<RepositoryType, Error>) -> Void)
    func fetchImage(_ endpoint: EndPoint, completion: @escaping (Result<UIImage?, Error>) -> Void)
}
