import Foundation
import CoreData

class ListRepository: Repository {
    typealias RepositoryType = Character
    
    func fetch(_ endpoint: EndPoint, completion: @escaping (Result<Character, Error>) -> Void) {
        URLSession.fetch(endpoint, completion: completion)
    }
    
    func cancel(_ endpoint: EndPoint, urlCache: [EndPoint : Bool]) {
        URLSession.cancel(endpoint)
    }
}
