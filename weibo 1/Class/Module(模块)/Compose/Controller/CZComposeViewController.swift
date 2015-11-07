
import UIKit

class CZComposeViewController: UIViewController {
    
    // MARK: - 属性
    /// toolBar底部约束
    private var toolBarBottomCon: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 需要设置背景颜色,不然弹出时动画有问题
        view.backgroundColor = UIColor.whiteColor()
        
        prepareUI()
        
        // 添加键盘frame改变的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /*
    notification:NSConcreteNotification 0x7f8fea5a4e20 {name = UIKeyboardDidChangeFrameNotification; userInfo = {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.25";    // 动画时间
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {375, 258}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {187.5, 796}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {187.5, 538}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 667}, {375, 258}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 409}, {375, 258}}"; // 键盘最终的位置
    UIKeyboardIsLocalUserInfoKey = 1;
    }}
    */
    
    /// 键盘frame改变
    func willChangeFrame(notification: NSNotification) {
     //   print("notification:\(notification)")
        
        // 获取键盘最终位置
        let endFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        
        // 动画时间
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        
        toolBarBottomCon?.constant = -(UIScreen.height() - endFrame.origin.y)
        
        UIView.animateWithDuration(duration) { () -> Void in
            // 不能直接更新toolBar的约束
            //            self.toolBar.layoutIfNeeded()
            
            self.view.layoutIfNeeded()
        }
    }
    

    
    // MARK: - 准备UI
    private func prepareUI() {
        setupNavigationBar()
        setupToolBar()
        setupTextView()
    }
    /// 设置导航栏
    private func setupNavigationBar() {
        // 设置按钮, 左边
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
        
        // 右边
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: "sendStatus")
        navigationItem.rightBarButtonItem?.enabled = false
        
        setupTitleView()
    }
    
    /// 设置toolBar
    private func setupToolBar() {
        // 添加子控件
        view.addSubview(toolBar)
        
        // 添加约束
        let cons = toolBar.ff_AlignInner(type: ff_AlignType.BottomLeft, referView: view, size: CGSize(width: UIScreen.width(), height: 44))
        
        // 获取底部约束
        toolBarBottomCon = toolBar.ff_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
        
        // 创建toolBar item
        var items = [UIBarButtonItem]()
        
        // 每个item对应的图片名称
        let itemSettings = [["imageName": "compose_toolbar_picture", "action": "picture"],
            ["imageName": "compose_trendbutton_background", "action": "trend"],
            ["imageName": "compose_mentionbutton_background", "action": "mention"],
            ["imageName": "compose_emoticonbutton_background", "action": "emoticon"],
            ["imageName": "compose_addbutton_background", "action": "add"]]
        
        var index = 0
        
        // 遍历 itemSettings 获取图片名称,创建items
        for dict in itemSettings {
            // 获取图片的名称
            let imageName = dict["imageName"]!
            
            // 获取图片对应点点击方法名称
            let action = dict["action"]!
            
            let item = UIBarButtonItem(imageName: imageName)
            
            // 获取item里面的按钮
            let button = item.customView as! UIButton
            button.addTarget(self, action: Selector(action), forControlEvents: UIControlEvents.TouchUpInside)
            
            items.append(item)
            
            // 添加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
            
            index++
        }
        
        // 移除最后一个弹簧
        items.removeLast()
        
        toolBar.items = items
    }
    
    /// 设置导航栏标题
    private func setupTitleView() {
        let prefix = "发微博"
        
        // 获取用户的名称
        if let name = CZUserAccount.loadAccount()?.name {
            // 有用户名
            let titleName = prefix + "\n" + name
            
            // 创建可变的属性文本
            let attrString = NSMutableAttributedString(string: titleName)
            
            // 创建label
            let label = UILabel()
            
            // 设置属性文本
            label.numberOfLines = 0
            label.textAlignment = NSTextAlignment.Center
            label.font = UIFont.systemFontOfSize(14)
            
            // 获取NSRange
            let nameRange = (titleName as NSString).rangeOfString(name)
            
            // 设置属性文本的属性
            attrString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(12), range: nameRange)
            attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: nameRange)
            
            // 顺序不要搞错
            label.attributedText = attrString
            label.sizeToFit()
            
            navigationItem.titleView = label
        } else {
            // 没有用户名
            navigationItem.title = prefix
        }
    }
    /// 设置textView
    private func setupTextView() {
        // 添加子控件
        view.addSubview(textView)
        
        /*
        前提:
        1.scrollView所在的控制器属于某个导航控制器
        2.scrollView控制器的view或者控制器的view的第一个子view
        */
        // scrollView会自动设置Insets, 比如scrollView所在的控制器属于某个导航控制器contentInset.top = 64
        //        automaticallyAdjustsScrollViewInsets = true
        
        // 添加约束
        // 相对控制器的view的内部左上角
        textView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: view, size: nil)
        // 相对toolBar顶部右上角
        textView.ff_AlignVertical(type: ff_AlignType.TopRight, referView: toolBar, size: nil)
    }
    
    // MARK: - 按钮点击事件
    func picture() {
        print("图片")
    }
    
    func trend() {
        print("#")
    }
    
    func mention() {
        print("@")
    }
    
    func emoticon() {
        print("表情")
    }
    
    func add() {
        print("加号")
    }

    
    /// 关闭控制器
    @objc private func close() {
        // 关闭键盘
        textView.resignFirstResponder()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// 发微博
    func sendStatus() {
        print(__FUNCTION__)
    }
    
    // MARK: - 懒加载
    /// toolBar
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        
        toolBar.backgroundColor = UIColor(white: 0.8, alpha: 1)
        
        return toolBar
        }()
    /*
    iOS中可以让用户输入的控件:
    1.UITextField:
    1.只能显示一行
    2.可以有占位符
    3.不能滚动
    
    2.UITextView:
    1.可以显示多行
    2.没有占位符
    3.继承UIScrollView,可以滚动
    */
    /// textView
    private lazy var textView: CZPlaceholderTextView = {
        let textView = CZPlaceholderTextView()
        
        // 当textView被拖动的时候就会将键盘退回,textView能拖动
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        textView.font = UIFont.systemFontOfSize(18)
        textView.backgroundColor = UIColor.brownColor()
        textView.textColor = UIColor.blackColor()
        textView.bounces = true
        textView.alwaysBounceVertical = true
        
        // 设置占位文本
        textView.placeholder = "分享新鲜事..."
        
        // 设置顶部的偏移
        textView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        
        // 设置控制器作为textView的代理来监听textView文本的改变
        textView.delegate = self
        
        return textView
        }()
}

extension CZComposeViewController: UITextViewDelegate {
    /// textView文本改变的时候调用
    func textViewDidChange(textView: UITextView) {
        // 当textView 有文本的时候,发送按钮可用,
        // 当textView 没有文本的时候,发送按钮不可用
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }


}

