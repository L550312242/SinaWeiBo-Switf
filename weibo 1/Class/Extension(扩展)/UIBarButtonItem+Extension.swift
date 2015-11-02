
import UIKit
extension UIBarButtonItem{
    
    convenience init(imageName:String)
    {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "\(imageName)_highlighted"), forState: UIControlState.Highlighted)
        button.sizeToFit()
        self.init(customView:button)
    }
    
    //不创建对象就调用，生成一个UIBarButtonItem
    func navigaitonItem(imageName: String) -> UIBarButtonItem {
                let button = UIButton()
                button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
                button.setImage(UIImage(named: "\(imageName)_highlighted"), forState: UIControlState.Highlighted)
                button.sizeToFit()
                return UIBarButtonItem(customView: button)
            }

}