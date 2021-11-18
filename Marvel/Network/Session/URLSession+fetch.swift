import Foundation
import OSLog

public protocol Session {
    static var endpointCache: [EndPoint: Bool] { get set }
    static func fetch<T: Decodable>(_ endpoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void)
    static func cancel(_ endpoint: EndPoint)
}

extension URLSession: Session {
    public static var endpointCache: [EndPoint : Bool] = [:]
    public static func fetch<T>(_ endpoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        
//        guard endpointCache[endpoint] != true else { completion(.failure(Errors.parsing as! Error)); return }
        endpointCache[endpoint] = true
        let request = URLRequest(endpoint: endpoint)
//        guard Reachability.isConnectedToNetwork() else {
//            let dataProvider = DataProvider()
//            dataProvider.disabledNetwork()
//            
//        }
        
        Self.shared.dataTask(with: request) { data, response, error in
            do {
                if let error = error {
                    Logger.log.error("Error - \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    Logger.log.error("Error - No error was received but we also don't have data...")
                    preconditionFailure("No error was received but we also don't have data...")
                }
                
                Logger.log.info("\nResponse: \(String(data: data, encoding: .utf8)!)")
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                Logger.log.error("Error - \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    public static func cancel(_ endpoint: EndPoint) {
        let request = URLRequest(endpoint: endpoint)
        guard endpointCache[endpoint] == true else { return }
        let dataTask = URLSession.shared.dataTask(with: request)
        dataTask.cancel()
    }
}
