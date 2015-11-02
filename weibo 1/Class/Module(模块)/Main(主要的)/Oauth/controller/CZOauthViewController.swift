

import UIKit
import SVProgressHUD

class CZOauthViewController: UIViewController {
    override func loadView() {
        view = webView
        //设置代理
        webView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //    view.backgroundColor = UIColor.brownColor()
        // 没有的背景颜色的时候modal出来的时候动画奇怪
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "填充", style: UIBarButtonItemStyle.Plain, target: self, action: "autoFill")
        //加载网页
        let request = NSURLRequest(URL: CZNetwoorkTools.shareInstance.oauthRUL())
        webView.loadRequest(request)

    }
    /// 自动填充账号密码
    func autoFill() {
        let js = "document.getElementById('userId').value='550312242@qq.com';" + "document.getElementById('passwd').value='luoliguo741';"
        
        // webView执行js代码
        webView.stringByEvaluatingJavaScriptFromString(js)
    }
    ///关闭控制器
    func close(){
        dismissViewControllerAnimated(true , completion: nil)
    }
  //MARK: -- 懒加载 --
    private lazy var webView = UIWebView()
}
//MAKE:  - 扩展 CZOauthViewController 实现 UIWebViewDelegate 协议
extension CZOauthViewController: UIWebViewDelegate{
    //开始加载请求
    func webViewDidStartLoad(webView: UIWebView) {
        //显示正在加载
        //showWithStatus 不主动关闭，会一直显示
       SVProgressHUD.showWithStatus("正在加载...",maskType:SVProgressHUDMaskType.Black)
        
    }
    //加载请求完毕
    func webViewDidFinishLoad(webView: UIWebView) {
     
        //关闭
        SVProgressHUD.dismiss()
    }
    //询问是否加载，request
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let urlString = request.URL!.absoluteString
        print("urlString:\(urlString)")
        
       //加载的不是回调地址
          //  if !urlString.hasPrefix(CZNetwoorkTools.shareInstance.redirect_uri)
        if !urlString.hasPrefix(CZNetwoorkTools.shareInstance.redirect_uri)
        {
            return true   //可以加载
        }
        
        //如果点击的是确定或取消拦截不加载
        if let query = request.URL?.query{
            print("query:\(query)")
            let codeString = "code="
            if query.hasPrefix(codeString){
                //确实
                //转成NSString
                let nsQuery = query as NSString
                //截取code的值
                let code  = nsQuery.substringFromIndex(codeString.characters.count)
                 //获取assess token
                loadAccessToken(code)
            }else{
                //取消
            }
        }
        return false
    }
    /**
    调用网络工具类去加载加载access token
    - parameter code: code
    */
    func loadAccessToken(code: String){
        CZNetwoorkTools.shareInstance.loadAccessToken(code){(result, error) -> () in
            if error != nil || result == nil{
             //   self.
//                SVProgressHUD.showErrorWithStatus("网络不给力",maskType:SVProgressHUDMaskType.Black)
//                // 延迟关闭. dispatch_after 没有提示,可以拖oc的dispatch_after来修改
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
//                    self.close()
//                })
                self.netError("网络不给力")
                return
            }
            let account = CZUserAccount(dict: result!)
            //保存到沙盒
            account.saveAccount()
            //加载用户数据
            account.loadUserInfo({ (error) ->() in if error != nil{
                self.netError("加载用户数据出错...")
                return
                }
                print("account:\(CZUserAccount.loadAccount())")
                self.close()
                (UIApplication.sharedApplication().delegate as! AppDelegate).switchRootController(false)
            })
        //    SVProgressHUD.dismiss()
        }
    }

private func netError(message:String){
    SVProgressHUD.showErrorWithStatus("网络不给力",maskType:SVProgressHUDMaskType.Black)
    
    // 延迟关闭. dispatch_after 没有提示,可以拖oc的dispatch_after来修改
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
        self.close()
    })
  }
}