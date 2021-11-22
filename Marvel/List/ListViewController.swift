import UIKit
import CoreData

class ListViewController: UITableViewController, UITableViewDataSourcePrefetching {
    private let repo = ListRepository()
    private let dataProvider = DataProvider()
    private lazy var viewModel: ListViewModel = DefaultListViewModel(repo: repo, dataProvider: dataProvider)
    private let searchController = UISearchController(searchResultsController: nil)
    private var offset = 0
    private var filteredData: [Results] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    private var data: [Results] = [] {
        didSet {
            offset = ((data.count/10) + 1) * 10
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.getResults(offset: 0) { [weak self] results in
            self?.data = results
        }
    }
    
    private func configureUI() {
        tableView.estimatedRowHeight = 296
        tableView.rowHeight = UITableView.automaticDimension
        tableView.prefetchDataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Marvel heros"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        tableView.registerNib(for: ListCell.self)
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
        viewModel.getImages(result: result) { image in
            DispatchQueue.main.async {
                cell.albumImageView.image = image
            }
        }
        cell.titleLabel.text = result.name
        return cell
        
    }
    
    private func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.row >= self.data.count
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            guard indexPath.row >= self.data.count - tableView.visibleCells.count else { return }
            viewModel.getResults(offset: offset) { results in
                self.data += results
            }
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
      let searchBar = searchController.searchBar
      filterContentForSearchText(searchBar.text!)
  }
    
    func filterContentForSearchText(_ searchText: String,
                                    category: Results? = nil) {
      filteredData = data.filter { (result: Results) -> Bool in
        return result.name.lowercased().contains(searchText.lowercased())
      }
    }
}
