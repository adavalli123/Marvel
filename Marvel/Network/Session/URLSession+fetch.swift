import Foundation
import OSLog
import UIKit
import Combine

public protocol Session {
    static func fetch<T: Decodable>(_ endpoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void)
    static func fetchImage(_ endpoint: EndPoint, completion: @escaping (Result<UIImage?, Error>) -> Void)
}

extension URLSession: Session {
    public static func fetchImage(_ endpoint: EndPoint, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        Self.fetchData(endpoint) { result in
            switch result {
            case .success(let data):
                completion(.success(UIImage(data: data)))
            case .failure(let error):
                Logger.log.error("Error - \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    public static func fetch<T>(_ endpoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        Self.fetchData(endpoint) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch let error {
                    Logger.log.error("Error - \(error.localizedDescription)")
                    completion(.failure(error))
                }
            case .failure(let error):
                Logger.log.error("Error - \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    private static func fetchData(_ endpoint: EndPoint, completion: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(endpoint: endpoint)
        Self.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                Logger.log.error("Error - \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                Logger.log.error("Error - No error was received but we also don't have data...")
                preconditionFailure("No error was received but we also don't have data...")
            }
            completion(.success(data))
        }.resume()
    }
}
