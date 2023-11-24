//
//  RequestDataModel.swift
//   
//
//  Created by  hech on 2021/3/5.
//



import HandyJSON


/// 返回消息体
struct RequestDataModel<T>: HandyJSON {
    var data: T?    // 数据体
    var error_message: String = ""  // 返回提示字符串
    var status: String = ""  // 返回提示字符串
}



struct RequestListDataModel<T>: HandyJSON {
    var data: ListDataModel<T>?    // 数据体
    var message: String = ""  // 返回提示字符串
    var code: String = ""    //状态码, 200正确
    var status: String = ""  // 返回提示字符串
    var success: Bool = false    //状态码, 200正确
}

struct ListDataModel<T>: HandyJSON {
    var data: [T]?    // 数据体
    var pageIndex: Int?
    var pageSize: Int?
    var total: Int?
}

struct RequestError {
//    var data: T?    // 数据体
    var message: String = ""
    var code: String = ""
    
}

