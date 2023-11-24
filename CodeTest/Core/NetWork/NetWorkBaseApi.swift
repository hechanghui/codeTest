//
//  NetWorkBaseApi.swift
//   
//
//  Created by  hech on 2021/1/8.
//

import Foundation
import Moya
import UIKit


enum RequestType {
    case GET
    case POST
    case DELETE
    case PUT
}

enum ContentType {
    case Form
    case Json
}



private var tempPath: String?
private var tempParam: [String:Any]?
private var tempEncodabl: Encodable?
private var requestType: RequestType?
private var contentType: ContentType?
private var tmpTask: Task?


class Target : TargetType{

    static var token : String?
    
    var clientId : String = "ios_app"
    
    static var pageNum : Int?
//    typealias complateClosure = (Dictionary<String, Any>?, Error?) -> (Void)
//    typealias complateClosure = (RequestDataModel?, Bool) -> Void
    
    
    class func callRequestWithControl<T:Any>(path: String, params: [String: Any] , pageNum : Int? = nil, type: RequestType, onComplete: @escaping (RequestDataModel<T>?, RequestError?) -> Void )  {
        self.pageNum = pageNum
        tempPath = path
        requestType = type
        contentType = ContentType.Form
        tmpTask = Task.requestParameters(parameters: params, encoding: URLEncoding.default)
        NetWorkManager.shared.request(target: Target(), completion: onComplete)
    }
    
        
    // post请求body 形式
    class func callPostBodyRequestWithControl<T: Any>(path: String, json: [String: Any], onComplete: @escaping (RequestDataModel<T>?, RequestError?) -> Void )  {

        tempPath = path
        requestType = RequestType.POST
        tmpTask = Task.requestParameters(parameters: json, encoding: JSONEncoding.default)
        NetWorkManager.shared.request(target: Target(), completion: onComplete)
        

    }
    
    
    
    var baseURL: URL {
        return URL.init(string: NetWorkConfig.hostUrl)!
    }

    var path: String {
        return tempPath ?? ""
    }

    var method: Moya.Method {
    
        switch requestType {
        case .GET:
            return .get
        case .POST:
            return .post
        case .DELETE:
            return .delete
        case .PUT:
            return .put
        case .none:
            return .get
        }
    }

    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }

    var task: Task {
        
        return tmpTask!
//        switch contentType {
//        case .Form:
//            return .requestParameters(parameters: tempParam ?? [:], encoding: URLEncoding.default)
//        case .Json:
//            return tmpTask!
//        default:
//            break
//        }
//
//        return   .requestParameters(parameters: tempParam ?? [:], encoding: URLEncoding.default)

    }

    var headers: [String : String]? {
    
//        print(ADAccountManager.share.authorization)
//        let time = getMilliSec()
        var dic : [String : String] = [:]
//            "deviceInfo" : devInfo() , //用户信息
//            "clientId": clientId,
//            "appVersion" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
//            "Authorization": Target.token ?? "",
//            "timestamp" : time,
         
//        ]
 
        
        return dic
    }
    
   
}





