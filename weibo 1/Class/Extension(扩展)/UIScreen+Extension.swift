//
//  UIScreen+Extension.swift
//  weibo 1
//
//  Created by sa on 15/11/4.
//  Copyright © 2015年 sa. All rights reserved.
//

import UIKit
extension UIScreen {
    //提供直接返回屏幕高度
    
    class func height() -> CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
    
    //提供直接返回屏幕宽度
    class func width() -> CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    
}
