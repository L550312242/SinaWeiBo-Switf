
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
    static let shareInstance: CZNetworkTools = CZNetworkTools()
    override init() {
        let urlString = "https://api.weibo.com/"
        afnManager = AFHTTPSessionManager(baseURL: NSURL(string: urlString))
        afnManager.responseSerializer.acceptableContentTypes?.insert("text/plain")
        //        return tool
    }
    //创建单例
//    static let shareInstance: CZNetworkTools = {
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
            print("result:\(result   )")
            finshed(result: result as? [String:AnyObject], error: nil)
            }){(_,errno:NSError) -> Void in
         finshed(result: nil, error: errno)
        }
    }
    //MAKE: - 获取用户信息
    func locadUserInfo(finshed: NetworkFinishedCallback){
        
        //判断accessToken
        if CZUserAccount.loadAccount()?.access_token == nil{
            print("没有accessToken")
            // 自定义error
            // domain: 自定义,表示错误范围
            // code: 错误代码:自定义.负数开头,
            // userInfo: 错误附加信息
//          let error = NSError(domain: "cn.itcast.error.network", code: -1, userInfo: ["description" : "没有accessToken"])
            let error = CZNetworkError.emptyToken.error()
            //告诉调用者
            finshed(result: nil, error: error)
            return
            // 创建枚举
        }
        // 判断uid
        if CZUserAccount.loadAccount()?.uid == nil
        {
           let error = CZNetworkError.emptyUid.error()
            //告诉调用者
        finshed(result: nil, error: error)
            return
        }
        //url
        let urlString = "https://api.weibo.com/2/users/show.json"
        //参数
        let parameters = [
            "accessToken": CZUserAccount.loadAccount()!.access_token!,"uid":CZUserAccount.loadAccount()!.uid!
        ]
        requestGET(urlString,parameters:parameters, finshed:finshed)
//        //发送请求
//       afnManager.GET(urlString, parameters: parameters, success: { (_, result) -> Void in
//            finshed(result: result as? [String: AnyObject], error: nil)
//            }) { (_, error) -> Void in
//                finshed(result: nil, error: error)
//        }

    }
    typealias NetworkFinishedCallback = (result: [String: AnyObject]?, error: NSError?) -> ()

    //MARK:  --- 封装AFN.GET ---
    func requestGET(URLString: String, parameters: AnyObject?, finshed: NetworkFinishedCallback) {
        
        afnManager.GET(URLString, parameters: parameters, success: { (_, result) -> Void in
            finshed(result: result as? [String: AnyObject], error: nil)
            }) { (_, error) -> Void in
                finshed(result: nil, error: error)
        }
    }
}
