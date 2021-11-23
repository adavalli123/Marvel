import UIKit

class ListCell: UITableViewCell {
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImageView.image = nil
        titleLabel.text = ""
    }
}

