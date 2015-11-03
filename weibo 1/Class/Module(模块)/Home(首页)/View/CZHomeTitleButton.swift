//
//  CZHomeTitleButton.swift
//  weibo 1
//
//  Created by sa on 15/11/2.
//  Copyright © 2015年 sa. All rights reserved.
//

import UIKit

class CZHomeTitleButton: UIButton {

    override func layoutSubviews() {
          super.layoutSubviews()
        //改变箭头位置
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.width + 3
    }

}
