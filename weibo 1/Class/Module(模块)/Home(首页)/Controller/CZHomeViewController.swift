//
//  CZHomeViewController.swift
//  weibo 1
//
//  Created by sa on 15/10/27.
//  Copyright © 2015年 sa. All rights reserved.
//

import UIKit
import AFNetworking

class CZHomeViewController: CZBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if !CZUserAccount.userLogin(){
            return
        }
        setupNavgaiotnBar()
    }
    //设置导航栏
    private func setupNavgaiotnBar() {
//        let leftButton = UIButton()
//        leftButton.setImage(UIImage(named: "navigationbar_friendsearch"), forState: UIControlState.Normal)
//        leftButton.setImage(UIImage(named: "navigationbar_friendsearch_highlighted"), forState: UIControlState.Highlighted)
//        leftButton.sizeToFit()
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
//        
//        let rightButton = UIButton()
//        rightButton.setImage(UIImage(named: "navigationbar_pop"), forState: UIControlState.Normal)
//        rightButton.setImage(UIImage(named: "navigationbar_friendsearch_highlighted"), forState: UIControlState.Highlighted)
//        rightButton.sizeToFit()
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
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
//    //生成一个带按钮的UIBarButtonItem
//    func nvigaitonItem(imageName:String) -> UIBarButtonItem{
//        let button = UIButton()
//        button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
//        button.setImage(UIImage(named: "\(imageName)_highlighted"), forState: UIControlState.Highlighted)
//        button.sizeToFit()
//        return UIBarButtonItem(customView: button)
//    }
}
