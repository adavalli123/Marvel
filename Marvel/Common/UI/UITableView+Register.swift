import UIKit

extension UITableView {
    func registerNib(for cell: UITableViewCell.Type) {
        let nib = UINib(nibName: String(describing: cell), bundle: nil)
        register(nib, forCellReuseIdentifier: String(describing: cell))
    }
}
