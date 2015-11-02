

import UIKit

private let reuseIdentifier = "Cell"

class CZNewFeatureViewController: UICollectionViewController {

    ///MARK: 属性
    private let itemCount = 4
    private var layout = UICollectionViewFlowLayout()
    init(){
        super.init(collectionViewLayout: layout)
    }
    required init?(coder aDecoder:NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.collectionView!.registerClass(CZNewFeatuerCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        prepareLayout()
    }
//设置layout的参数
    private func prepareLayout()
    {
        //设置item的大小
        layout.itemSize = UIScreen.mainScreen().bounds.size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        //分页
        collectionView?.pagingEnabled = true
        //取消弹簧效果
        collectionView?.bounces = false
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return itemCount
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as!CZNewFeatuerCell
    
        cell.imageIndex = indexPath.item
//        cell.startButtonAnmation()
    
        return cell
    }
    // collectionView显示完毕cell
    // collectionView分页滚动完毕cell看不到的时候调用
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
   // override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    
        //正在显示的cell的indexPath
        let showIndexPath = collectionView.indexPathsForVisibleItems().first!
      //获取collectionView正在显示的cell
        let cell = collectionView.cellForItemAtIndexPath(showIndexPath) as! CZNewFeatuerCell
        //最后一页动画
        if showIndexPath.item == itemCount - 1{
            //开始动画
            cell.startButtonAnmation()
        }
    }
}
//自定义cell
    class CZNewFeatuerCell:UICollectionViewCell {
        //MARK: 属性
        //监听属性值的改变 cell 即将显示的时候会调用
        var imageIndex: Int = 0{
            didSet{
                //知道当前是哪一页
                //设置图片
                backgroundImageView.image = UIImage(named: "new_feature_\(imageIndex + 1)")
                startButton.hidden = true
            }
        }
      //  var imageIndex: Int
        //构造方法
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
         override init(frame: CGRect) {
            super.init(frame: frame)
            
            prepareUI()
        }
        //MARK: --- 开启按钮动画
        func startButtonAnmation(){
            startButton.hidden = false
            //把按扭的transform 缩放设置为0
            startButton.transform = CGAffineTransformMakeScale(0, 0)
            //动画执行
            UIView.animateWithDuration(1, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options:UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
               self.startButton.transform = CGAffineTransformIdentity
                }) { (_) -> Void in
                    
            }
        }
     /*  override init(frame:CGRect) {
            super.init(frame:frame)
             prepareUI()
        }
        */
        /// MARK: --- 准备UI ---
        private func prepareUI(){
            //添加子控件
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(startButton)
            //添加约束
            backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
            startButton.translatesAutoresizingMaskIntoConstraints = false
            //VFL
           contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[bak]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bak" :backgroundImageView]))
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[bck]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bck": backgroundImageView]))
            //开始体验按钮
            contentView.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
            contentView.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -160))
          
        }
        //点击事件
       
//            func startButtonClick() {
//                (UIApplication.sharedApplication().delegate as! AppDelegate).switchRootController(true)
//            }
//         func startButtonClick(){
//            (UIApplication.sharedApplication().delegate as! AppDelegate).switchRootController(true)
//        }
        private lazy var backgroundImageView = UIImageView()
        //开始体验
        private lazy var startButton: UIButton = {
            let button = UIButton()
            //设置背景按钮
            button.setBackgroundImage(UIImage(named: "new_feature_finish_button"), forState: UIControlState.Normal)
            button.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), forState: UIControlState.Highlighted)
            //设置文字
            button.setTitle("开始体验", forState: UIControlState.Normal)
            //添加按钮点击事件
            button.addTarget(self, action: "startButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
            return button
        }()
    }


