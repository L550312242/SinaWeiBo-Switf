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
        window?.rootViewController = defaultController()
        
        //成为主窗口并显示
        window?.makeKeyAndVisible()
        
        return true
    }
    private func defaultController() -> UIViewController {
        //判断是否登录
         // 每次判断都需要 == nil
        if !CZUserAccount.userLogin() {
            return CZMainViewController()
        }
        //  判断是否是新版本
      return  isNewVersion() ? CZNewFeatureViewController() : CZWelcomeViewController()
    }
    //判断是否是新版本
    private func isNewVersion() -> Bool{
        //获取当前版本号
    let versionString = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        let currentVersion = Double(versionString)!
        print("currentVersion: \(currentVersion)")
        //获取到之前的版本号
        let sandboxVersionKey = "sandboxVersionKey"
        let sandboxVersion = NSUserDefaults.standardUserDefaults().doubleForKey(sandboxVersionKey)
        print("sandboxVersion: \(sandboxVersion)")
        //保存当前版本号
        NSUserDefaults.standardUserDefaults().setDouble(currentVersion, forKey: sandboxVersionKey)
        //对比
        return currentVersion > sandboxVersion
    }
    // MARK: - 切换根控制器
    
    /**
    切换根控制器
    - parameter isMain: true: 表示切换到MainViewController, false: welcome
    */
    func switchRootController(isMain: Bool) {
        window?.rootViewController = isMain ? CZMainViewController() : CZWelcomeViewController()
    }
    
    private func setupAppearance() {
        // 尽早设置
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
    }
}

