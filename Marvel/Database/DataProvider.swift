import Firebase
import Foundation

class DataProvider {
    let db = Database.shared.db()
    
    func save(character: Character) {
        character.data.results.forEach { result in
            db.collection(.resultPath).document(String(describing: result.id)).setData(dict(from: result))
        }
    }
    
    func fetchAll(closure: @escaping (Result<[Results], Error>) -> ()) {
        db.collection(.resultPath).order(by: "name")
        
        var results: [Results] = []
        //        let semaphore = DispatchSemaphore(value: 0)
        
        db.collection(.resultPath).getDocuments { querySnapshot, error in
            querySnapshot?.documents.forEach { document in
                results.append(
                    Results(
                        id: document.data()[.id] as! Int,
                        name: document.data()[.name] as! String,
                        thumbnail: Thumbnail(
                            path: document.data()[.path] as! String,
                            thumbnailExtension: document.data()[.ext] as! String
                        ),
                        urls: [
                            URLElement(
                                type: document.data()[.type] as! String,
                                url: document.data()[.url] as! String
                            )
                        ]
                    )
                )
            }
            
            closure(.success(results))
            //            if querySnapshot?.documents.count == results.count {
            //                semaphore.signal()
            //            }
        }
        
        //        semaphore.wait()
        //        return results
    }
    
    func disabledNetwork() {
        db.disableNetwork { error in
            //            fetchAll(closure: <#T##(Result<[Results], Error>) -> ()#>)
        }
    }
    
    private func dict(from result: Results) -> [String: Any] {
        return [
            .name: result.name,
            .id: result.id,
            .path: result.thumbnail.path,
            .ext: result.thumbnail.thumbnailExtension
        ]
    }
}

private extension String {
    static let resultPath = "results"
    
    static let name = "name"
    static let id = "id"
    static let thumbnail = "thumbnail"
    static let path = "path"
    static let ext = "ext"
    static let type = "resourceURI"
    static let url = "comicsName"
}

