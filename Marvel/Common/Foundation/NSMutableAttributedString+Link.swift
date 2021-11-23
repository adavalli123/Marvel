import UIKit.UIFont

extension NSMutableAttributedString {
    public func setAsLink(textToFind:String, linkURL:String) {
        let foundRange = self.mutableString.range(of: textToFind)
        guard foundRange.location != NSNotFound else { return }
        self.addAttribute(.link, value: linkURL, range: foundRange)
        self.addAttribute(.font, value: UIFont.systemFont(ofSize: 17), range: foundRange)
    }
}

