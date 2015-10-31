//
//  AppDelegate.swift
//  weibo 1
//
//  Created by sa on 15/10/27.
//  Copyright © 2015年 sa. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //创造Window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.orangeColor()
        
        let tabbar = CZMainViewController()
        //?: 如果？前面的变量有值才执行后面的代码
        window?.rootViewController = tabbar
        
        //成为主窗口并显示
        window?.makeKeyAndVisible()
        
        return true
    }
    
    // MARK: - 切换根控制器
    
    /**
    切换根控制器
    - parameter isMain: true: 表示切换到MainViewController, false: welcome
    */
//    func switchRootController(isMain: Bool) {
//        window?.rootViewController = isMain ? CZMainViewController() : CZWelcomeViewController()
//    }
    
    private func setupAppearance() {
        // 尽早设置
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
    }
}

