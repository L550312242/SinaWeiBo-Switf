//
//  UIColor+Extension.swift
//  weibo 1
//
//  Created by sa on 15/11/1.
//  Copyright © 2015年 sa. All rights reserved.
//

import UIKit

//扩展color的功能
extension UIColor{
    class func randomColor() -> UIColor{
        return UIColor(red: randomValue(), green: randomValue(), blue: randomValue(), alpha: 1)
    }
    //随机0 - 1 的值
    private class func randomValue() ->CGFloat{
       return CGFloat(arc4random_uniform(256)) / 255
    }
}
