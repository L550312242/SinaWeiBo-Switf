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
