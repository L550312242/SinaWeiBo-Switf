

import UIKit

class CZMainViewController: UITabBarController {
    func composeButtonClick(){
        //_Function_ 打印方法名称
        print(__FUNCTION__)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor.orangeColor()
        
        //首页
        let homeVc = CZHomeViewController()
        self.addChildViewController(homeVc, title: "首页", imageName: "tabbar_home")
        //消息
        let messageVc = CZMessageViewController()
        self.addChildViewController(messageVc, title: "消息", imageName: "tabbar_message_center")
        
        //使用一个空的来顶替
        let controller = UIViewController()
        addChildViewController(controller, title: "", imageName: "f")
        
       //发现
        let discoverVc = CZDiscoverController()
        self.addChildViewController(discoverVc, title: "发现", imageName:"tabbar_discover")
      
        
        //我
        let profileVc = CZProfileViewController()
        self.addChildViewController(profileVc , title: "我", imageName: "tabbar_profile")
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let width = tabBar.bounds.width / CGFloat(5)
        composeButton.frame = CGRect(x: 2 * width, y: 0, width: width, height: tabBar.bounds.height)
        tabBar.addSubview(composeButton)
    }
    /**
    添加子控制器,包装Nav
    - parameter controller: 控制器
    - parameter title:      标题
    - parameter imageName:  图片名称
    */
    private func addChildViewController(contorller : UIViewController,title:String,imageName:String) {
        
        contorller.title = title
        contorller.tabBarItem.image = UIImage(named: imageName)
        addChildViewController(UINavigationController(rootViewController: contorller))
    }
    
    // MAKE: -- 懒加载
    lazy var composeButton: UIButton = {
        let button = UIButton()
        
        //按钮图片
        button.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        //添加按钮背景
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
       button.addTarget(self, action: "composeButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        
      //  self.addSubview(button)
        return button
    }()
    
}
