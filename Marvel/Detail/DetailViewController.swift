//
//  DetailViewController.swift
//  Marvel
//
//  Created by Srikanth Adavalli on 11/20/21.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var coverImagetView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlTextView: UITextView!
    var result: Results?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let result = result else { return }

        let url = result.thumbnail.path + "." + result.thumbnail.thumbnailExtension
        coverImagetView.loadImage(urlString: url) { _ in }
        titleLabel.text = result.name
        
        let urlText = result.urls.map { $0.type }.joined(separator: "\t")
        let mutableAttributeString = NSMutableAttributedString(string: urlText)
        result.urls.forEach { element in
            mutableAttributeString.setAsLink(textToFind: element.type, linkURL: element.url)
        }
        urlTextView.attributedText = mutableAttributeString
        urlTextView.textAlignment = .center
    }
}

extension NSMutableAttributedString {
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            self.addAttribute(.font, value: UIFont.systemFont(ofSize: 17), range: foundRange)
            return true
        }
        return false
    }
}

@IBDesignable
public extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    @IBInspectable var topLeft: Bool {
        get { return layer.maskedCorners.contains(.layerMinXMinYCorner) }
        set {
            if newValue {
                layer.maskedCorners.insert(.layerMinXMinYCorner)
            } else {
                layer.maskedCorners.remove(.layerMinXMinYCorner)
            }
        }
    }

    @IBInspectable var topRight: Bool {
        get { return layer.maskedCorners.contains(.layerMaxXMinYCorner) }
        set {
            if newValue {
                layer.maskedCorners.insert(.layerMaxXMinYCorner)
            } else {
                layer.maskedCorners.remove(.layerMaxXMinYCorner)
            }
        }
    }

    @IBInspectable var bottomLeft: Bool {
        get { return layer.maskedCorners.contains(.layerMinXMaxYCorner) }
        set {
            if newValue {
                layer.maskedCorners.insert(.layerMinXMaxYCorner)
            } else {
                layer.maskedCorners.remove(.layerMinXMaxYCorner)
            }
        }
    }

    @IBInspectable var bottomRight: Bool {
        get { return layer.maskedCorners.contains(.layerMaxXMaxYCorner) }
        set {
            if newValue {
                layer.maskedCorners.insert(.layerMaxXMaxYCorner)
            } else {
                layer.maskedCorners.remove(.layerMaxXMaxYCorner)
            }
        }
    }
}
