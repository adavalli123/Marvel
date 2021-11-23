import Foundation
import UIKit

protocol DetailViewModelInput: AnyObject { }

protocol DetailViewModelOutput {
    func getImages(result: Results, closure: @escaping (UIImage?) -> ())
}

protocol DetailViewModel: DetailViewModelOutput { }

class DefaultDetailViewModel: DetailViewModel {
    private let repo: ListRepository?
    private let dataProvider: DataProvider
    
    required init(repo: ListRepository, dataProvider: DataProvider) {
        self.repo = repo
        self.dataProvider = dataProvider
    }
    
    // MARK: Fetching Images
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
}
