
import UIKit
/*
iOS保存数据的方式:
1.plist
2.偏好设置
3.归档
4.sqlite
5.CoreData
*/

//NSCoding  要实现归档，先添加NSCoding协议
class CZUserAccount: NSObject, NSCoding{
    
    // 当做类方法. 返回值就是属性的类型
    // 有账号返回true
    class func userLogin() -> Bool {
        return CZUserAccount.loadAccount() != nil
    }
    //用于调用access_token, 接口获取授权的Access token
    var access_token: String?
    //access_token的生命周期，单位是秒数
    //对于基本数据类型不能定义为可选
 //   var expires_in: NSTimeInterval = 0
    var expires_in: NSTimeInterval = 0 {
        didSet{
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    //当前授权用户的UID
    var uid: String?
    
    //过期时间
    var expires_date: NSDate?
    
    // 好友显示名称
    var name: String?
    
    /// 用户头像地址（大图），180×180像素
    var avater_large: String?

    // KVC 字典转模型
    init(dict: [String: AnyObject]) {
        
        super.init()
        // 将字典里面的每一个key的值赋值给对应的模型属性
        setValuesForKeysWithDictionary(dict)
    }
    // 当字典里面的key在模型里面没有对应的属性
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    override var description: String {
        return "access_token:\(access_token), expires_in:\(expires_in), uid:\(uid): expires_date:\(expires_date),name:\(name), avater_large:\(avater_large)"
    }
    //MARK -- 加载用户信息 --
    // 控制调用这个方法,不管成功还是失败,都需要告诉调用者
    func loadUserInfo(finsh:(error:NSError?) ->()){
        CZNetworkTools.shareInstance.locadUserInfo{ (result, error) ->() in if error != nil || result == nil{
           finsh (error: error)
      //       print("----result\(result)")

            return
        }
      //      print("----result\(result)")
            //加载成功
            self.name = result!["name"] as? String
            self.avater_large = result!["avatar_large"] as? String//avatar_large
      //   print("wang:avater_large\(self.avater_large)")
            //保存到沙盒
            self.saveAccount()
            
            //同步到内存，把当前对象赋值给内存中的 userAccount
           CZUserAccount.userAccount = self
            finsh (error: nil)
           
        }
    }
    // 类方法访问属性需要将属性定义成 static
    // 对象方法访问static属性需要类名.属性名称
    static let accountPath = NSSearchPathForDirectoriesInDomains( NSSearchPathDirectory.DocumentDirectory,  NSSearchPathDomainMask.UserDomainMask, true).last! + "/Account.plist"

     // MARK: - 保存对象
    func saveAccount(){
        // account.plist
        NSKeyedArchiver.archiveRootObject(self, toFile: CZUserAccount.accountPath)
    }
        //类方法访问属性需要将属性定义成Static
    private static var userAccount: CZUserAccount?
    
    //加载loadAccount 是用频繁，解档账号比较耗性能，只能加载一次，保存到内存中，以后访问内存中的账号
    class func loadAccount() -> CZUserAccount? {
        //判断内存中有没有
        if userAccount == nil {
            //内存中没有才来解档，并赋值给内存中的账号
            userAccount = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? CZUserAccount
        }
        // 判断如果有账号,还需要判断是否过期
        // NSDate(): 表示当前时间 2015
        // userAccount?.expires_date: 2020
        // userAccount?.expires_date > NSDate(): 没有过期
        // OrderedAscending (<  升序) OrderedSame (= 相等) OrderedDescending (> 降序)
        
        // 测试时间过期
        //        userAccount?.expires_date = NSDate(timeIntervalSinceNow: -100)  // 比当前时间早100秒
        //        print(userAccount?.expires_date)
        //        print("当前时间:\(NSDate())")
        if userAccount != nil && userAccount?.expires_date?.compare(NSDate()) == NSComparisonResult.OrderedDescending {
            print("账号有效:\(userAccount)")
            return userAccount
        }
        return nil
    }
    
    // MARK: --- 归档和解档
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_date, forKey: "expires_date")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(avater_large, forKey: "avater_large")
    }
    required init?(coder aDecoder:NSCoder){
        access_token = aDecoder.decodeObjectForKey("access_token") as?String
        expires_in = aDecoder.decodeDoubleForKey("expires_in")
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_date = (aDecoder.decodeObjectForKey("expires_date") as? NSDate)!
        name = aDecoder.decodeObjectForKey("name") as? String
        avater_large = aDecoder.decodeObjectForKey("avater_large") as? String
    }
}
