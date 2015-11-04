 //
//  CZStatus.swift
//  weibo 1
//
//  Created by sa on 15/11/3.
//  Copyright © 2015年 sa. All rights reserved.
//

import UIKit

class CZStatus: NSObject {
    /// 微博创建时间
    var created_at: String?
    
    /// 微博ID
    var id: Int = 0
    
    /// 微博信息内容
    var text: String?
    
    /// 微博来源
    var source: String?
    
    // 通过分析微博返回的数据 是一个数组,数组里面是一个字典["thumbnail_pic": url]
    /// 微博的配图
    var pic_urls: [[String: AnyObject]]?
    
    //用户模型
    var user: CZUser?

    // 字典转模型
    init(dict:[String: AnyObject]){
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    //KVC赋值每个属性的时候都会调用
    override func setValue(value: AnyObject?, forKey key: String) {
        //判断user赋值时，自己字典转模型
        if key == "user"
        {
            if let dict = value as? [String: AnyObject]{
                //字典转模型
                //赋值
                user = CZUser(dict: dict)
                //一定要记得return,不加就会调用父类
                return
            }
        }
        return super.setValue(value, forKey: key)
    }
    //字典的key在模型里面找不到对应的属性
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
   override var description: String{
    let p = ["created_at", "idstr", "text", "source", "pic_urls","user"]
    //数组里面的每个元素，找到对应的Value,平成字典
//    dictionaryWithValuesForKeys(p)
    // 数组里面的每个元素,找到对应的value,拼接成字典
    // \n 换行, \t table
    return "\n\t微博模型:\(dictionaryWithValuesForKeys(p))"
    }
    //加载微博数据
  class func loadSyatus(finished: (statuses: [CZStatus]?, error: NSError?) -> ()){
        CZNetworkTools.shareInstance.loadStatus { (result, error) -> () in
            if error != nil{
            print("error:\(error)")
                //通知调用者
                return
    }
            //   判断是否有数据
            if let array = result?["statuses"] as? [[String:AnyObject]]{
//                有数据
                //创建模型数组
                var statuses = [CZStatus]()
                for dict in array{
                    //字典转模型
                    statuses.append(CZStatus(dict: dict))
                }
                //字典转模型完成
                //print("statuses:\(statuses)")
                //通知调用者
                finished(statuses: statuses, error: nil)
            }else {
                //没有数据
            }
           
        }
    }
}
