import Foundation
import CoreData
import UIKit

class ListRepository: Repository {
    typealias RepositoryType = Character
    
    func fetch(_ endpoint: EndPoint, completion: @escaping (Result<Character, Error>) -> Void) {
        URLSession.fetch(endpoint, completion: completion)
    }
    
    func fetchImage(_ endpoint: EndPoint, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        URLSession.fetchImage(endpoint, completion: completion)
    }
}
