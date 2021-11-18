//
//  ListCell.swift
//  Marvel
//
//  Created by Srikanth Adavalli on 11/20/21.
//

import Foundation
import UIKit

class ListCell: UITableViewCell {
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    func registerNib(for cell: UITableViewCell.Type) {
        let nib = UINib(nibName: String(describing: cell), bundle: nil)
        register(nib, forCellReuseIdentifier: String(describing: cell))
    }
}
