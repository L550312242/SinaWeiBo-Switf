

import UIKit

//定义协议
protocol CZVistorViewDelegate: NSObjectProtocol{
    
    func vistorViewRegistClick()  // 注册
    
    func vistorViewLoginClick()  //登陆
    
}

class CZVistorView: UIView {
    
    //属性
    weak var vistorViewDelegate: CZVistorViewDelegate?
    
    //MARK: --- 按钮点击事件 ---
    //注册
    func redistClick(){
        vistorViewDelegate?.vistorViewRegistClick()
        
    }
    
    //登陆
    func loginClick()
    {
        vistorViewDelegate?.vistorViewLoginClick()
    }
        //MARK : -- 构造函数 --
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame:CGRect){
        super.init(frame:frame)
       prepareUI()
    }
    // MARK: - 设置访客视图内容
    /**s
    设置访客视图内容,出了首页
    - parameter imageName: 图片名称
    - parameter message:   消息
    */
    func setupVistorView(imageName: String, message: String)
    {
        //隐藏房子
        homeView.hidden = true
        
        iconView.image = UIImage(named: imageName)
        
        messageLabel.text = message
        
        self.sendSubviewToBack(coverView)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(iconView.layer.animationKeys())
    }
    //转轮动画
    func startRotationAnimation(){
        //创建动画
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        //设置参数
        animation.toValue = 2 * M_PI
        animation.repeatCount = MAXFLOAT
        animation.duration = 20
        //完成的时候不移除
        animation.removedOnCompletion = false
        
        //开始动画
        iconView.layer.addAnimation(animation, forKey: "homeRotation")
   }
    //旋转暂停
    func pauseAnimation()
    {
        //记录暂停时间
        let pauseTime = iconView.layer.convertTime(CACurrentMediaTime(), toLayer: nil)
        //设置动画属性为零
        iconView.layer.speed = 0
        //设置动画偏移时间
        iconView.layer.timeOffset = pauseTime
    }
    //回复旋转
    func resumeAnimation() {
        //获取暂停时间
        let pauseTime = iconView.layer.timeOffset
        //设置动画转速为1
        iconView.layer.speed = 1
        iconView.layer.timeOffset = 0
        iconView.layer.beginTime = 0
        let timeSincePause = iconView.layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pauseTime
        iconView.layer.beginTime = timeSincePause
    }
    // 准备UI
    func prepareUI()
    {
        backgroundColor = UIColor(white: 237/255, alpha: 1)
        //添加子控件
         addSubview(iconView)
        addSubview(homeView)
        addSubview(coverView)
        addSubview(messageLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        //设置约束
        iconView .translatesAutoresizingMaskIntoConstraints = false
        coverView.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        homeView.translatesAutoresizingMaskIntoConstraints = false
        //创建约束
        //转轮
        //CenterX
        self.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -40))
        //小房子
        addConstraint(NSLayoutConstraint(item: homeView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: homeView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -40))
        //消息label
          addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
          addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
        //width

          addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 240))
        //注册按钮
        //左边
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
        //  顶部
          addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
           //  宽度
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100))
            // 高度
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 35))
        //登陆按钮
        //右边
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0))
        //  顶部
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
        //  宽度
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100))
        // 高度
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 35))
        //遮盖
        //X
        addConstraint(NSLayoutConstraint(item: coverView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
        //右边
        addConstraint(NSLayoutConstraint(item: coverView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0))
        //Y
        addConstraint(NSLayoutConstraint(item: coverView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        //底部
        addConstraint(NSLayoutConstraint(item: coverView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: registerButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
    }
        func test(){
            //创建约束
            //centreX
        let cX = NSLayoutConstraint(item: iconView
            , attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        self.addConstraint(cX)
             //centreY
        let cY = NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 50)
        self.addConstraint(cY)
        
    }
    //Mark: -- 懒加载
    
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        //创建图片
        let image = UIImage(named: "visitordiscover_feed_image_smallicon")
        imageView.image = image
        
        
        return imageView
    }()
    //小房子 只有首页
    private lazy var homeView: UIImageView = {
       let imageView = UIImageView()
        //设置图片
        let image = UIImage(named: "visitordiscover_feed_image_house")
        imageView.image = image
        imageView.sizeToFit()
        return imageView
    }()
    
    //消息文字
    private lazy var messageLabel: UILabel = {
       let label = UILabel()
        //设置文字
        label.text = "关注一些人，看看有什么惊喜"
        label.textColor = UIColor.lightGrayColor()
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    //注册按钮
    private lazy var registerButton:UIButton = {
       let button = UIButton()
        //设置文字
        button.setTitle("注册", forState: UIControlState.Normal)
        //设置文字颜色
        button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        //设置背景
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        button.sizeToFit()
        return button
    }()
    //登陆按钮
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        //设置文字
        button.setTitle("登陆", forState: UIControlState.Normal)
        //设置文字颜色
        button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        //设置背景
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        button.sizeToFit()
        return button
        }()
    //遮盖
    private lazy var coverView: UIImageView = {
       let image = UIImage(named: "visitordiscover_feed_mask_smallicon")
        return UIImageView(image: image)
    }()
}
