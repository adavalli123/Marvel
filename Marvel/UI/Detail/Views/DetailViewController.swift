import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var coverImagetView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlTextView: UITextView!
    
    private let repo = ListRepository()
    private let dataProvider =  DefaultDataProvider()
    private lazy var viewModel: DetailViewModel = DefaultDetailViewModel(repo: repo, dataProvider: dataProvider)
    
    var result: Results?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let result = result else { return }
        configureUI(result: result)
    }
    
    private func configureUI(result: Results) {
        titleLabel.text = result.name
        
        let urlText = result.urls.map { $0.type }.joined(separator: "\t")
        let mutableAttributeString = NSMutableAttributedString(string: urlText)
        result.urls.forEach { element in
            mutableAttributeString.setAsLink(textToFind: element.type, linkURL: element.url)
        }
        urlTextView.attributedText = mutableAttributeString
        urlTextView.textAlignment = .center
        
        viewModel.getImages(result: result) { [weak self] image in
            DispatchQueue.main.async {
                self?.coverImagetView.image = image
            }
        }
    }
}
