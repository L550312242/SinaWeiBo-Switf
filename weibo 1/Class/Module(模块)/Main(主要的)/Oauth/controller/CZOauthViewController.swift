//
//  CZOauthViewController.swift
//  weibo 1
//
//  Created by sa on 15/10/30.
//  Copyright © 2015年 sa. All rights reserved.
//

import UIKit

class CZOauthViewController: UIViewController {
    override func loadView() {
        view = webView
        //设置代理
//        webView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 没有的背景颜色的时候modal出来的时候动画奇怪
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
        //加载网页
      //  let request = NSURLRequest

    }
  //MARK: -- 懒加载 --
    private lazy var webView = UIWebView()
}
//MAKE: --
