
import UIKit

import AFNetworking

class CZNetwoorkTools: AFHTTPSessionManager {
    
    //创建单例
    static let shareInstance: CZNetwoorkTools = {
      
        let urlString = "https://api.weibo.com/"
        
        let tool = CZNetwoorkTools(baseURL: NSURL(string: urlString))
        
        tool.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tool
    }()
    // MARK: - OAtuh授权
    /// 申请应用时分配的AppKey
    private let client_id = "501566062"
    
    /// 申请应用时分配的AppSecret
    
    private let client_secret = "85c06597321e71f6147fb2384e284c23"
    
    //请求的类型，填写authorization_code
    private let grant_type = "authorization_code "
    
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
    func loadAccessToken(code: String , finshed: (result:[String:AnyObject]?,error:NSError?) ->()){
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
        POST(urlString, parameters: parameters, success: { (_, result ) -> Void in
            print("result:\(result )")
            finshed(result: result as? [String:AnyObject], error: nil)
            }){(_,errno:NSError) -> Void in
         finshed(result: nil, error: errno)
        }
    }
}
