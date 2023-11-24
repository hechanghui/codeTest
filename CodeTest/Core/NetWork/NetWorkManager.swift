//
//  NetWorkManager.swift
//   
//
//  Created by  hech on 2021/1/8.
//

import Foundation
import Moya
import Alamofire

//超时时间
private var requestTimeOut: Double = 15
//是否打印请求信息
private let NetWorkLog = true

struct NetWorkManager {
    
    //MARK: - Closures
//    typealias complateClosure = (Dictionary<String, Any>?, Error?) -> (Void)
//    typealias complateClosure = (RequestDataModel?, Bool) -> Void
    
    //MARK: - getters setters
    private let endpointClosure = { (target: Target) -> Endpoint in
        let url = target.baseURL.absoluteString + target.path
        var endpoint = Endpoint(
            url: url,
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
        return endpoint
    }
    
    private let requestClosure = { (endpoint: Endpoint, closure: MoyaProvider.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = requestTimeOut
            
            if NetWorkLog {
                
                if let requestData = request.httpBody {
                    debugPrint("\(request.url!)"+"\n"+"\(request.httpMethod ?? "")"+"发送参数"+"\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")")
                }else{
                    debugPrint("\(request.url!)"+"\n\(String(describing: request.httpMethod))")
                }
            }
            closure(.success(request))
            
        } catch {
            closure(.failure(MoyaError.underlying(error, nil)))
        }
    }
    
    private let networkPlugin = NetworkActivityPlugin.init { (changeType, targetType) in
        switch(changeType){
        case .began:
            debugPrint("开始请求")
        case .ended:
            debugPrint("请求结束")
        }
    }
    
    
    //MARK:- life
    static let shared = NetWorkManager()
    private init() {}
    
    
    //MARK: - public methods
    
    //取消所有请求
//    func cancelAllRequest() {
//
//        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler {
//            (sessionDataTask, uploadData, downloadData) in
//            sessionDataTask.forEach { $0.cancel() }
//            uploadData.forEach { $0.cancel() }
//            downloadData.forEach { $0.cancel() }
//        }
//    }
    
    //取消指定URL的请求
//    func cancelRequest(url: String){
//        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler {
//            (sessionDataTask, uploadData, downloadData) in
//            sessionDataTask.forEach {
//                if ($0.originalRequest?.url?.absoluteString == url) {
//                    $0.cancel()
//                }
//            }
//        }
//    }
    
    //网络状态判断
//    func currentNetReachability()  {
//        let manager = NetworkReachabilityManager()
//
//        manager?.listener = { status in
//            var statusStr: String?
//            switch status {
//            case .unknown:
//                statusStr = "未识别的网络"
//                break
//            case .notReachable:
//                statusStr = "不可用的网络(未连接)"
//
//                //toast
//                return
//            case .reachable:
//                if (manager?.isReachableOnWWAN)! {
//                    statusStr = "2G,3G,4G...的网络"
//                } else if (manager?.isReachableOnEthernetOrWiFi)! {
//                    statusStr = "wifi的网络"
//                }
//                break
//            }
//            debugPrint(statusStr as Any)
//        }
//        manager?.startListening()
//    }
    
    //判断是否设置了代理
//    private func isUsedProxy() -> Bool {
//        guard let proxy = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() else { return false }
//        guard let dict = proxy as? [String: Any] else { return false }
////        let isUsed = dict.isEmpty // 有时候未设置代理dictionary也不为空，而是一个空字典
//        guard let HTTPProxy = dict["HTTPProxy"] as? String else { return false }
//        if HTTPProxy.count > 0 {
//            print('')
//            MCToast.mc_failure("代理禁止访问")
//            return true
//        }
//        return false
//    }
    
    
    //MARK: - request
    func request<T>(target: Target, completion: @escaping (RequestDataModel<T>?, RequestError?) -> Void) {
        //判断网络状态
//        currentNetReachability()
        //判断是否设置了代理
//       if isUsedProxy() == true {
//           return
//       }
        let provider = MoyaProvider(endpointClosure: endpointClosure, requestClosure: requestClosure, plugins: [networkPlugin], trackInflights: false)
        
        debugPrint("header: \(target.headers)")
        provider.request(target) { (result) in
            switch result {
                
            case let .success(response):
                do {
                    //转JSON
                    let responseDict = try JSONSerialization.jsonObject(with: response.data)
                    guard let dic = responseDict as? Dictionary<String, Any> else {
                        debugPrint("不是json数据")
                        return
                    }
                    
                    let model = RequestDataModel<T>.deserialize(from: dic)
                    debugPrint(dic)
                    
                    
                    if model != nil && model?.status == "ok" {
                        completion(model, nil)
                    } else {
                        //错误其他状态码
                      
                        var error = RequestError();
                        error.message = model?.error_message ?? "";
                        debugPrint("错误的url: \(target.path)")
                        completion(model, error)
                    }
                } catch {
                    debugPrint("数据转字典失败")
                    var dataModel = RequestDataModel<T>.init()
                    dataModel.error_message = "数据格式错误"
                    
                    var error = RequestError();
                    error.message = dataModel.error_message;
                    debugPrint("错误的url: \(target.path)")
                    completion(dataModel, error)
                }
            case let .failure(error):
                var msg = "网络连接失败"
                if let errorDescription = error.errorDescription {
//
                    debugPrint("网络请求失败:\(errorDescription)")
                    msg = "亲，您的网络不给力！"
                }else {
                    //网络连接失败
                    debugPrint("网络连接失败")
                }
                
                var dataModel = RequestDataModel<T>.init()
                dataModel.error_message = msg
                
                var error = RequestError();
                error.message = dataModel.error_message;
                debugPrint("错误的url: \(target.path)")
                completion(dataModel, error)
                
            }
        }
    }
    
    func setToken(token : String){
        Target.token = token
    }
}

