//
//  CZHomeViewController.swift
//  weibo 1
//
//  Created by sa on 15/10/27.
//  Copyright © 2015年 sa. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD

class CZHomeViewController: CZBaseTableViewController {
    //MARK:  --  属性 --
    //微博模型数组
    private var statuses: [CZStatus]?{
        didSet{
            tableView.reloadData()
           
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !CZUserAccount.userLogin(){
            return
        }
        setupNavgaiotnBar()
        prepareTablrView()
         print("加载微博数据")
        
        //   TODO: 测试获取微博数据
     
        CZStatus.loadSyatus { (statuses, error) -> () in
            if error != nil{
                SVProgressHUD.showErrorWithStatus("加载数据失败", maskType: SVProgressHUDMaskType.Black)
                return
            }
            // 能到下面来说明没有错误
            if statuses == nil || statuses?.count == 0{
                SVProgressHUD.showErrorWithStatus("没有新的微博数据", maskType: SVProgressHUDMaskType.Black)
                return
            }
//            有微博数据
            self.statuses = statuses
   //         print("statuses:\(statuses)")
        }
    }
    private func prepareTablrView() {
        //tabelView 注册cell
        tableView .registerClass(CZStatusCell.self, forCellReuseIdentifier:"cell")
        
        //设置预估行高
        tableView .estimatedRowHeight = 200
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
    //生成一个带按钮的UIBarButtonItem
    func nvigaitonItem(imageName:String) -> UIBarButtonItem{
        let button = UIButton()
        button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "\(imageName)_highlighted"), forState: UIControlState.Highlighted)
        button.sizeToFit()
        return UIBarButtonItem(customView: button)
    }
    //MARK: -- tabeView 代理和数据源 ---
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return statuses?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //设置cell
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as!CZStatusCell
        
          //设置cell模型
        cell.status = statuses?[indexPath.row]
        return cell
    }
}