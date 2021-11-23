import Firebase
import Foundation

protocol DataProviderInput {
    func deleteAll()
    func save(character: Character)
    func save(image: UIImage?, on id: Int)
}

protocol DataProviderOutput {
    func enableNetwork(_ completion: ((Error?) -> Void)?)
    func disabledNetwork(name: String, closure: @escaping (Result<[Results], Error>) -> ())
    func disabledNetwork(url: String, id: Int, closure: @escaping (UIImage?) -> ())
}

protocol DataProvider: DataProviderInput, DataProviderOutput { }

final class DefaultDataProvider: DataProvider {
    private let db = Database.shared.db()
    
    // MARK: Delete
    func deleteAll() {
        deleteCollection()
    }
    
    // MARK: Save
    func save(character: Character) {
        character.data.results.forEach { result in
            db.collection(.resultPath).document(String(describing: result.id)).setData(dict(from: result))
        }
    }
    
    func save(image: UIImage?, on id: Int) {
        guard let data = image?.pngData() else { return }
        db.collection(.imagePath).document(String(describing: id)).setData(["\(id)": data])
    }
    
    // MARK: Offline Data
    func disabledNetwork(name: String, closure: @escaping (Result<[Results], Error>) -> ()) {
        db.disableNetwork { [weak self] error in
            self?.fetchAll(name: name, closure: closure)
        }
    }
    
    func disabledNetwork(url: String, id: Int, closure: @escaping (UIImage?) -> ()) {
        db.disableNetwork { [weak self] error in
            self?.fetchImage(for: id, url: url, closure: closure)
        }
    }
    
    // MARK: Fetching from Firebase/Local Firebase
    private func fetchImage(for id: Int, url: String, closure: @escaping (UIImage?) -> ()) {
        db.collection(.imagePath).document(String(describing: id)).getDocument(completion: { document, error in
            guard error == nil else {
                closure(UIImage(named: "notAvailable"))
                return
            }
            guard let data = document?.data()?[String(describing: id)] as? Data else { closure(nil); return}
            closure(UIImage(data: data))
        })
    }
    
    private func fetchAll(name: String, closure: @escaping (Result<[Results], Error>) -> ()) {
        var ref: Query?
        if !name.isEmpty {
            ref = db.collection(.resultPath).order(by: "name").limit(to: 10).start(after: [name])
        } else {
            ref = db.collection(.resultPath).order(by: "name").limit(to: 10)
        }
        
        var results: [Results] = []
        ref?.getDocuments { querySnapshot, error in
            querySnapshot?.documents.forEach { document in
                let urlElements: [URLElement] = (document.data()[.urls] as! [String: String]).map { element in
                    URLElement(type: element.key, url: element.value)
                }
                
                results.append(
                    Results(
                        id: document.data()[.id] as! Int,
                        name: document.data()[.name] as! String,
                        thumbnail: Thumbnail(
                            path: document.data()[.path] as! String,
                            thumbnailExtension: document.data()[.ext] as! String
                        ),
                        urls: urlElements
                    )
                )
            }
            
            closure(.success(results))
        }
    }
    
    // MARK: Enable Network
    func enableNetwork(_ completion: ((Error?) -> Void)?) {
        db.enableNetwork(completion: completion)
    }
        
    // MARK: Helpers
    private func urlsDict(from urls: [URLElement]) -> [String: String] {
        var dict: [String: String] = [:]
        urls.forEach { dict[$0.type] = $0.url }
        return dict
    }
    
    private func dict(from result: Results) -> [String: Any] {
        return [
            .name: result.name,
            .id: result.id,
            .path: result.thumbnail.path,
            .ext: result.thumbnail.thumbnailExtension,
            .urls: urlsDict(from: result.urls)
        ]
    }
    
    // MARK: Collection Deletion
    /// Resetting all paths - Here it is images/Results path
    private func deleteCollection() {
        delete(collection: db.collection(.imagePath)) { error in
            print(error.debugDescription)
        }
        
        delete(collection: db.collection(.resultPath)) { error in
            print(error.debugDescription)
        }
        
        func delete(collection: CollectionReference, batchSize: Int = 100, completion: @escaping (Error?) -> ()) {
            // Limit query to avoid out-of-memory errors on large collections.
            // When deleting a collection guaranteed to fit in memory, batching can be avoided entirely.
            collection.limit(to: batchSize).getDocuments { (docset, error) in
                // An error occurred.
                guard let docset = docset else {
                    completion(error)
                    return
                }
                // There's nothing to delete.
                guard docset.count > 0 else {
                    completion(nil)
                    return
                }

                let batch = collection.firestore.batch()
                docset.documents.forEach { batch.deleteDocument($0.reference) }

                batch.commit { (batchError) in
                    if let batchError = batchError {
                        // Stop the deletion process and handle the error. Some elements
                        // may have been deleted.
                        completion(batchError)
                    } else {
                        delete(collection: collection, batchSize: batchSize, completion: completion)
                    }
                }
            }
        }
    }
}

private extension String {
    static let resultPath = "results"
    static let imagePath = "images"
    
    static let name = "name"
    static let id = "id"
    static let thumbnail = "thumbnail"
    static let path = "path"
    static let ext = "ext"
    static let type = "resourceURI"
    static let urls = "urls"
}

