

import UIKit
import AFNetworking
import SVProgressHUD

// 统一管理cell的ID
enum CZStatusCellIdentifier: String {
    case NormalCell = "NormalCell"
    case ForwardCell = "ForwardCell"
}


class CZHomeViewController: CZBaseTableViewController {
    //MARK:  --  属性 --
    //微博模型数组
    private var statuses: [CZStatus]? {
        didSet {
            tableView.reloadData()
           
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !CZUserAccount.userLogin(){
            return
    }
        setupNavgaiotnBar()
        prepareTabelView()
        // 默认高度60,宽度是屏幕的宽度
        // 自定义 UIRefreshControl,在 自定义的UIRefreshControl添加自定义的view
        refreshControl = CZRefreshControl()
        //添加下拉刷新响应事件
        refreshControl?.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
        // 调用beginRefreshing开始刷新,但是不会触发 ValueChanged 事件,只会让刷新控件进入刷新状态
        refreshControl?.beginRefreshing()
        
        // 代码触发 refreshControl 的 ValueChanged 事件
        refreshControl?.sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }
    
    func loadData() {
         print("加载微博数据")
        var since_id = statuses?.first?.id ?? 0
        var max_id = 0
        
        // 如果菊花正在转,表示 上拉加载更多数据
        if pullUpView.isAnimating() {
            // 上拉加载更多数据
            since_id = 0
            max_id = statuses?.last?.id ?? 0 // 设置为最后一条微博的id
    }

        
     //   TODO: 测试获取微博数据
    CZStatus.loadStatus(since_id, max_id: max_id) { (statuses, error) -> () in
    //    CZStatus.loadSyatus { (statuses, error) -> () in
        // 关闭下拉刷新控件
        self.refreshControl?.endRefreshing()
        
        // 将菊花停止
        self.pullUpView.stopAnimating()

            if error != nil{
                SVProgressHUD.showErrorWithStatus("加载数据失败", maskType: SVProgressHUDMaskType.Black)
                return
            }
            // 能到下面来说明没有错误
            if statuses == nil || statuses?.count == 0 {
                SVProgressHUD.showErrorWithStatus("没有新的微博数据", maskType: SVProgressHUDMaskType.Black)
                return
            }
        
        // 下拉刷新,显示加载了多少条微博
        if since_id > 0 {
            let count = statuses?.count ?? 0
            self.showTipView(count)
        }
        
        // 能到下面来说明没有错误
        if statuses == nil || statuses?.count == 0 {
            SVProgressHUD.showInfoWithStatus("没有新的微博数据", maskType: SVProgressHUDMaskType.Black)
            return
        }
        
        // 判断如果是下拉刷新,加获取到数据拼接在现有数据的前
        if since_id > 0 {   // 下拉刷新
            // 最新数据 =  新获取到的数据 + 原有的数据
            print("下拉刷新,获取到: \(statuses?.count)");
            self.statuses = statuses! + self.statuses!
        } else if max_id > 0 {  // 上拉加载更多数据
            // 最新数据 =  原有的数据 + 新获取到的数据
            print("上拉加载更多数据,获取到: \(statuses?.count)");
            self.statuses = self.statuses! + statuses!
        } else {

//            有微博数据
            self.statuses = statuses
   //         print("statuses:\(statuses)")
        }
    }
}
    /// 显示下拉刷新加载了多少条微博
    private func showTipView(count: Int) {
        let tipLabelHeight: CGFloat = 44
        let tipLabel = UILabel()
        tipLabel.frame = CGRect(x: 0, y: -20 - tipLabelHeight, width: UIScreen.width(), height: tipLabelHeight)
        
        tipLabel.textColor = UIColor.whiteColor()
        tipLabel.backgroundColor = UIColor.orangeColor()
        tipLabel.font = UIFont.systemFontOfSize(16)
        tipLabel.textAlignment = NSTextAlignment.Center
        
        tipLabel.text = count == 0 ? "没有新的微博" : "加载了 \(count) 条微博"
        
        // 导航栏是从状态栏下面开始
        // 添加到导航栏最下面
        navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)
        
        let duration = 0.75
        // 开始动画
        UIView.animateWithDuration(duration, animations: { () -> Void in
            // 让动画反过来执行
            //            UIView.setAnimationRepeatAutoreverses(true)
            
            // 重复执行
            //            UIView.setAnimationRepeatCount(5)
            tipLabel.frame.origin.y = tipLabelHeight
            }) { (_) -> Void in
                
                UIView.animateWithDuration(duration, delay: 0.3, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                    tipLabel.frame.origin.y = -20 - tipLabelHeight
                    }, completion: { (_) -> Void in
                        tipLabel.removeFromSuperview()
                })
        }
    }
    private func prepareTabelView() {
        // 添加footView,上拉加载更多数据的菊花
        tableView.tableFooterView = pullUpView
        //tabelView 注册cell
       //原创微博cell
        tableView .registerClass(CZStatusNormalCell.self, forCellReuseIdentifier: CZStatusCellIdentifier.NormalCell.rawValue)

        // 转发微博cell
        tableView.registerClass(CZStatusForwardCell.self, forCellReuseIdentifier: CZStatusCellIdentifier.ForwardCell.rawValue)

        //去掉tabelView分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        //设置预估行高
   //     tableView .estimatedRowHeight = 300
        // 根据约束自己来设置高度
       // tabelView.rowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    //设置导航栏
    private func setupNavgaiotnBar() {

        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName:"navigationbar_friendsearch")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName:"navigationbar_pop")
        //获取用户名
        //??: 如果？？前面有值，拆包 赋值给 name，如果没有值将 ？？后面的值赋值给 name
        let name = CZUserAccount.loadAccount()?.name ?? "没有名称"
        print("name\(name)")
        //设置title
        let button = CZHomeTitleButton()
        button.setTitle(name, forState: UIControlState.Normal)
        button.setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button.sizeToFit()
        button.addTarget(self, action: "homeButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = button
        
    }
    //OC可以访问private方法
    @objc private func homeButtonClick(button: UIButton){
        
        //记录按钮箭头的状态
        button.selected = !button.selected
        var transform: CGAffineTransform?
        if button.selected{
            transform = CGAffineTransformMakeRotation(CGFloat(M_PI - 0.01))
        }else{
            transform = CGAffineTransformIdentity
        }
        UIView.animateWithDuration(0.25) { () -> Void in
            button.imageView?.transform = transform!
        }
        
    }
    // MARK: - tableView 代理和数据源
    
    // 使用 这个方法,会再次调用 heightForRowAtIndexPath,造成死循环
    //        tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
    // 返回cell的高度,如果每次都去计算行高,消耗性能,缓存行高,将行高缓存到模型里面
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // 获取模型
        let status = statuses![indexPath.row]
        
        // 去模型里面查看之前有没有缓存行高
        if let rowHeight = status.rowHeight {
            // 模型有缓存的行高
            //            print("返回cell: \(indexPath.row), 缓存的行高:\(rowHeight)")
            return rowHeight
        }
        // 没有缓存的行高
        
        let id = status.cellID()
        // 获取cell
        let cell = tableView.dequeueReusableCellWithIdentifier(id) as! CZStatusCell
        
        // 调用cell计算行高的方法
        let rowHeight = cell.rowHeight(status)
        //        print("计算: \(indexPath.row), cell高度: \(rowHeight)")
        
        // 将行高缓存起来
        status.rowHeight = rowHeight
        
        return rowHeight
    }
    
//    //生成一个带按钮的UIBarButtonItem
//    func nvigaitonItem(imageName:String) -> UIBarButtonItem{
//        let button = UIButton()
//        button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
//        button.setImage(UIImage(named: "\(imageName)_highlighted"), forState: UIControlState.Highlighted)
//        button.sizeToFit()
//        return UIBarButtonItem(customView: button)
//    }
    //MARK: -- tabeView 代理和数据源 ---
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 获取模型
        let status = statuses![indexPath.row]
        //设置cell
        let cell = tableView.dequeueReusableCellWithIdentifier(status.cellID())! as!CZStatusCell
        
        //设置cell模型
        cell.status = status
        // 当最后一个cell显示的时候来加载更多微博数据
        // 如果菊花正在显示,就表示正在加载数据,就不加载数据
        if indexPath.row == statuses!.count - 1 && !pullUpView.isAnimating() {
            // 菊花转起来
            pullUpView.startAnimating()
            
            // 上拉加载更多数据
            loadData()
        }
        return cell
    }
        // MARK: - 懒加载
        /// 上拉加载更多数据显示的菊花
        private lazy var pullUpView: UIActivityIndicatorView = {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            
            indicator.color = UIColor.whiteColor()
            
            return indicator
            }()
}