import UIKit
import CoreData

class ListViewController: UITableViewController, UITableViewDataSourcePrefetching {
    let repo = ListRepository()
    let dataProvider = DataProvider()
    var data: [Results] = [] {
        didSet { offset = ((data.count/30) + 1) * 30 }
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    var urlCache: [EndPoint: Bool] = [:]
    var isFetchInProgress = false
    var offset = 0
    var filteredData: [Results] = []
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 296
        tableView.rowHeight = UITableView.automaticDimension
        tableView.prefetchDataSource = self
        
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search Candies"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
        
        
        tableView.registerNib(for: ListCell.self)
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        urlCache[.characters(offset: 0)] = true
        showHUD()
        
//        dataProvider.fetchAll { data in
//            switch data {
//            case .success(let results):
//                self.data = results
//
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//
//            default:
//                break
//            }
//        }
        
        guard !isFetchInProgress else { return }
        self.isFetchInProgress = true
        repo.fetch(.characters(offset: 0)) { result in
            self.hideHUD()
            switch result {
            case .success(let characterData):
                self.isFetchInProgress = false
                self.data = characterData.data.results
                self.dataProvider.save(character: characterData)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            default:
                break
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredData.count : data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier, for: indexPath) as? ListCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        let result = isFiltering ? filteredData[indexPath.row] : data[indexPath.row]
        let url = result.thumbnail.path + "." + result.thumbnail.thumbnailExtension
        cell.albumImageView.loadImage(urlString: url)
        cell.titleLabel.text = result.name
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
//            guard indexPath.row >= data.count - offset/2 else {
//                return
//            }
            showHUD()
            guard !isFetchInProgress else { return }
            isFetchInProgress = true
            repo.fetch(.characters(offset: offset)) { result in
                self.isFetchInProgress = false
                self.hideHUD()
                switch result {
                case .success(let characterData):
                    self.data += characterData.data.results
                    self.dataProvider.save(character: characterData)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            repo.cancel(.characters(offset: data.count), urlCache: urlCache)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.result = isFiltering ? filteredData[indexPath.row] : data[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    // TODO
      let searchBar = searchController.searchBar
      filterContentForSearchText(searchBar.text!)
  }
    
    func filterContentForSearchText(_ searchText: String,
                                    category: Results? = nil) {
      filteredData = data.filter { (result: Results) -> Bool in
        return result.name.lowercased().contains(searchText.lowercased())
      }
      
      tableView.reloadData()
    }
}
