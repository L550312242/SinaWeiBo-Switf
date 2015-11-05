//
//  UIImageView+Extension.swift
//  weibo 1
//
//  Created by sa on 15/11/5.
//  Copyright © 2015年 sa. All rights reserved.
//

import UIKit
extension UIImageView {
    func cz_setImageWithURL(url: NSURL!) {
        sd_setImageWithURL(url)
    }
    
    func cz_setImageWithURL(url: NSURL!, placeholderImage placeholder: UIImage!)
    {
        sd_setImageWithURL(url, placeholderImage: placeholder)
    }
}
