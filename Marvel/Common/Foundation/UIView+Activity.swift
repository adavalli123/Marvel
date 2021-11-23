import MBProgressHUD
import UIKit

extension UIView {
    func showActivityIndicator() {
        MBProgressHUD.showAdded(to: self, animated: true)
    }
    
    func hideActivityIndicator() {
        MBProgressHUD.hide(for: self, animated: true)
    }
}
