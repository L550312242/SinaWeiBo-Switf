
import UIKit

import AFNetworking

enum CZNetworkError:Int{
    case emptyToken = -1
    case emptyUid = -2
    //枚举里面可以有属性
    var description: String{
        get{
            //根据枚举的类型返回对应的错误
            switch self{
            case CZNetworkError.emptyToken:
                return "accecc token 为空"
                case CZNetworkError.emptyUid:
                return "uid 为空"
            }
        }
    }
    //枚举可以定义方法
    func error() -> NSError{
        return NSError(domain: "cn.itcast.error.network", code: rawValue, userInfo: ["errorDescription" : description])
    }
}


class CZNetworkTools: NSObject {
    
    //创建属性
    private var afnManager: AFHTTPSessionManager
    //创建单例
    static let sharedInstance: CZNetworkTools = CZNetworkTools()
    
    override init() {
        let urlString = "https://api.weibo.com/"
        afnManager = AFHTTPSessionManager(baseURL: NSURL(string: urlString))
        afnManager.responseSerializer.acceptableContentTypes?.insert("text/plain")
        //        return tool
    }
    //创建单例
//    static let sharedInstance: CZNetworkTools = {
//      
//        let urlString = "https://api.weibo.com/"
//        
//        let tool = CZNetworkTools(baseURL: NSURL(string: urlString))
//        
//        tool.responseSerializer.acceptableContentTypes?.insert("text/plain")
//        return tool
//    }()
    // MARK: - OAtuh授权
    /// 申请应用时分配的AppKey
    private let client_id = "501566062"
    
    /// 申请应用时分配的AppSecret
    
    private let client_secret = "85c06597321e71f6147fb2384e284c23"
    
    //请求的类型，填写authorization_code
    private let grant_type = "authorization_code"
    
    //回调地址
     let redirect_uri = "http://www.baidu.com/"
    
     // OAtuhURL地址
    func oauthRUL() ->NSURL{
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
        return NSURL(string: urlString)!
    }
    
     // 使用闭包回调
    //MARK --加载AccessToken
    //加载AccessToken
    func loadAccessToken(code: String , finshed: NetworkFinishedCallback){
        //url
        let urlString = "oauth2/access_token"
        // NSObject  /oauth2/authorize
        // AnyObject, 任何 class
        // 参数
        let parameters = [
            "client_id": client_id,
            "client_secret": client_secret,
            "grant_type": grant_type,
            "code": code,
            "redirect_uri": redirect_uri
        ]
        
        //result //请求结果
      afnManager.POST(urlString, parameters: parameters, success: { (_, result ) -> Void in
        //    print("result:\(result)")
            finshed(result: result as? [String:AnyObject], error: nil)
            }) { (_,errno:NSError) -> Void in
         finshed(result: nil, error: errno)
        }
    }
    //MAKE: - 获取用户信息
    func locadUserInfo(finshed: NetworkFinishedCallback){
        
        //守卫,和可选绑定相反
        //  parameters代码块里面和外面都能使用
        guard var parameters = tokenDict() else{
        //guard var parameters = tokenDict() else {
        //来到这里表示有parameters值
            print("没有accessToken")
            
            // 自定义error
            // domain: 自定义,表示错误范围
            // code: 错误代码:自定义.负数开头,
            // userInfo: 错误附加信息
           
            let error = CZNetworkError.emptyToken.error()
            
            //告诉调用者
            finshed(result: nil, error: error)
            return
        
        }
        // 判断uid
        if CZUserAccount.loadAccount()?.uid == nil
        {
            print("没有uid")
           let error = CZNetworkError.emptyUid.error()
            //告诉调用者
        finshed(result: nil, error: error)
            return
        }
        //url
        //https://api.weibo.com/2/users/show.json?access_token=2.00mmnprD0MPWwX0cbad42a5dzzLvrD&uid=3543890412
        
        //https://api.weibo.com/2/users/show.json?access_Token=2.00mmnprD0MPWwX0cbad42a5dzzLvrD&uid=3543890412
       let urlString = "https://api.weibo.com/2/users/show.json"
        //添加元素
      
         parameters["uid"] = CZUserAccount.loadAccount()!.uid!
        requestGET(urlString, parameters: parameters, finshed: finshed)
    }
        //判断access Token是否有值，没有值返回nil,有值，生成一个 字典
      func tokenDict() -> [String:AnyObject]?
//        func tokenDict() -> [String: AnyObject]?
        {
            if CZUserAccount.loadAccount()?.access_token == nil{
                return nil
            }
            return ["access_token":CZUserAccount.loadAccount()!.access_token!]
        }
    // Mark: 获取微博数据
    /**
    加载微博数据
    - parameter since_id: 若指定此参数，则返回ID比since_id大的微博,默认为0
    - parameter max_id:   若指定此参数，则返回ID小于或等于max_id的微博,默认为0
    - parameter finished: 回调
    */
    func loadStatus(since_id: Int, max_id: Int, finished:NetworkFinishedCallback){
        guard var parameters = tokenDict()else{
            //能到这里来说明token没有值
            
            //告诉调用者
        finished(result: nil, error: CZNetworkError.emptyToken.error())
            return
        }
        // 添加参数 since_id和max_id
        // 判断是否有传since_id,max_id
        if since_id > 0 {
            parameters["since_id"] = since_id
        } else if max_id > 0 {
            parameters["max_id"] = max_id - 1
        }
        // access_token 有值
        let urlString = "2/statuses/home_timeline.json"
        // 网络不给力，加载本地数据
        if true {
            requestGET(urlString, parameters: parameters, finshed: finished)
        } else {
            loadLocalStatus(finished)
        }
        
    }
    private func loadLocalStatus(finished: NetworkFinishedCallback){
        //获取路径
     let path =  NSBundle .mainBundle().pathForResource("statuses", ofType: "json")
        //加载文件数据
        let data = NSData(contentsOfFile: path!)
        
        //转成json
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
            //有数据
            finished(result: json as? [String: AnyObject], error: nil)
        } catch {
            print("出异常了")
        }
       
    }
  

    // 类型别名 = typedefined
    typealias NetworkFinishedCallback = (result: [String: AnyObject]?, error: NSError?) -> ()

    //MARK:  --- 封装AFN.GET ---
    func requestGET(URLString: String, parameters: AnyObject?, finshed: NetworkFinishedCallback) {
        
   
        afnManager.GET(URLString, parameters: parameters, success: { (_, result) -> Void in
            finshed(result: result as? [String: AnyObject], error: nil)
            }) { (_, error) -> Void in
          
                finshed(result: nil, error: error)}
        }
    }
