import Foundation
import CoreData
import UIKit
import OSLog

var imageCache = NSCache<AnyObject, AnyObject>()

protocol ListViewModelOutput: AnyObject {
    func getResults(offset: Int, _ closure: @escaping ([Results]) -> Void)
    func getImages(result: Results, closure: @escaping (UIImage?) -> ())
}

protocol ListViewModel: ListViewModelOutput { }

class DefaultListViewModel: ListViewModel {
    private var lastFetchedName = ""
    private let repo: ListRepository?
    private let dataProvider: DataProvider
    private let limit = 10
    private var offset = 0
    private var wasAnyRequestsPending = false
    
    required init(repo: ListRepository, dataProvider: DataProvider) {
        self.repo = repo
        self.dataProvider = dataProvider
    }
    
    func getResults(offset: Int, _ closure: @escaping ([Results]) -> Void) {
        guard self.offset < offset || offset == 0 else { return }
        self.offset = offset
        guard !wasAnyRequestsPending else { return }
        wasAnyRequestsPending = true
        guard Reachability.isConnectedToNetwork() else {
            self.fetchFromLocalDB(closure)
            return
        }
        fetchFromRemote(closure)
    }
    
    func getImages(result: Results, closure: @escaping (UIImage?) -> ()) {
        let url = result.thumbnail.path + "." + result.thumbnail.thumbnailExtension
        if let cacheImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
            closure(cacheImage)
            return
        }
        
        guard Reachability.isConnectedToNetwork() else {
            self.fetchImagesFromLocalDB(url: url, id: result.id, closure: closure)
            return
        }
        
        fetchImagesFromRemote(url: url, id: result.id, closure: closure)
    }
    
    private func fetchImagesFromRemote(url: String, id: Int, closure: @escaping (UIImage?) -> ()) {
        repo?.fetchImage(.image(url: url), completion: { result in
            switch result {
            case .success(let image):
                self.dataProvider.save(image: image, on: id)
                imageCache.setObject((image ?? UIImage()) as UIImage, forKey: url as AnyObject)
                closure(image)
            case .failure(_):
                closure(nil)
            }
        })
    }
    
    private func fetchImagesFromLocalDB(url: String, id: Int, closure: @escaping (UIImage?) -> ()) {
        dataProvider.disabledNetwork(url: url, id: id) { image in
            imageCache.setObject((image ?? UIImage()) as UIImage, forKey: url as AnyObject)
            closure(image)
        }
    }
    
    private func fetchFromLocalDB(_ closure: @escaping ([Results]) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.dataProvider.disabledNetwork(name: self.lastFetchedName) { [weak self] results in
                switch results {
                case .success(let characterResults):
                    self?.wasAnyRequestsPending = false
                    self?.lastFetchedName = characterResults.last?.name ?? ""
                    closure(characterResults)
                case .failure(let error):
                    Logger.log.error("\([self]) - \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func fetchFromRemote(_ closure: @escaping ([Results]) -> Void) {
        dataProvider.enableNetwork { [weak self] error in
            guard error == nil, let self = self else { return }
            self.repo?.fetch(.characters(limit: self.limit, offset: self.offset), completion: { result in
                switch result {
                case .success(let characterResult):
                    self.dataProvider.save(character: characterResult)
                    self.wasAnyRequestsPending = false
                    self.lastFetchedName = characterResult.data.results.last?.name ?? ""
                    closure(characterResult.data.results)
                case .failure(let error):
                    Logger.log.error("\([self]) - \(error.localizedDescription)")
                }
            })
        }
    }
}
