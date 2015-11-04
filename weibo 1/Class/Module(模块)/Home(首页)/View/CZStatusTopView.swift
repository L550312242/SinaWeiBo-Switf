//
//  CZStatusTopView.swift
//  weibo 1
//
//  Created by sa on 15/11/3.
//  Copyright © 2015年 sa. All rights reserved.
//

import UIKit

class CZStatusTopView: UIView {
    // MARK: - 微博模型
    var status: CZStatus?{
        didSet {
            //设置视图内容
            //用户头像
            if let iconUrl = status?.user?.profile_image_url{
                iconView.sd_setImageWithURL(NSURL(string: iconUrl))
            }
            //名称
            nameLabel.text = status?.user?.name
            //时间
            timeLabel.text = status?.created_at
            //来源
            sourceLabel.text = "来自 ** 微博"
            //认证类型
            //判断
            //没有认证： -1  认证用户：0  企业认证:2,3,5  达人:220
            verifiedView.image  = status?.user?.verifiedTypeImage
        }
    }
    //构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame:CGRect){
        super.init(frame: frame)
        //设置背景
        
     //   backgroundColor = UIColor.brownColor()
        prepareUI()
    }
    //MARK: -- 准备UI --
    private func prepareUI(){
        //添加子控件
        addSubview(iconView)                /// 用户头像
        addSubview(nameLabel)               /// 用户名称
        addSubview(timeLabel)               /// 时间label
        addSubview(sourceLabel)             /// 来源
        addSubview(verifiedView)             /// 认证图标
        addSubview(memberView)            /// 会员等级
        
        //添加约束
        //头像约束
        iconView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: self, size: CGSize(width: 35, height: 35), offset: CGPoint(x: 8, y: 0))
        
        //用户名称
        nameLabel.ff_AlignHorizontal(type: ff_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 8, y: 0))
        //时间约束
        timeLabel.ff_AlignHorizontal(type: ff_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 8, y: 0))
        
        //来源
        sourceLabel.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: timeLabel, size: nil, offset: CGPoint(x: 8, y: 0))
        
        //会员等级
        memberView.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: nameLabel, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 8, y: 0))
        //认证图标
        verifiedView.ff_AlignInner(type: ff_AlignType.BottomRight, referView: iconView, size: CGSize(width: 17, height: 17), offset:CGPoint(x: 8.5, y: 8.5) )
    }
    // MARK: - 懒加载
    /// 用户头像
    private lazy var iconView = UIImageView()
    
    /// 用户名称
    private lazy var nameLabel: UILabel = UILabel(fonsize: 14, textColor: UIColor.darkGrayColor())
    
    /// 时间label
    private lazy var timeLabel: UILabel = UILabel(fonsize: 9, textColor: UIColor.orangeColor())
    
    /// 来源
    private lazy var sourceLabel: UILabel = UILabel(fonsize: 9, textColor: UIColor.lightGrayColor())
    
    /// 认证图标
    private lazy var verifiedView = UIImageView()
    
    /// 会员等级
    private lazy var memberView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
}
