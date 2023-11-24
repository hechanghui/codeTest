//
//  Notification+Apptools.swift
//  AngelDoctor
//
//  Created by dsq on 2021/1/12.
//

import UIKit

//全局通知
extension Notification.Name{
    
    //eg
    //static let myNotifi = Notification.Name("myNoti")
    
    ///支付成功
    static let NotiPaySucc = Notification.Name("NotiPaySucc")
    ///支付失败
    static let NotiPayFail = Notification.Name("NotiPayFail")
    ///更改孕期状态通知
    static let NotiPregnancyChangeStatus = Notification.Name("NotiPregnancyChangeStatus")
    ///选择城市
    static let NotiSelectCity = Notification.Name("NotiSelectCity")
    
    ///选择城市
    static let NotiSelectHospital = Notification.Name("NotiSelectHospital")
    
    ///选择城市
    static let OrderChange = Notification.Name("OrderChange")
    
    ///选
    static let PregnantChange = Notification.Name("PregnantChange")
    
    //产康设备错误
    static let PostpartumDeviceError = Notification.Name("PostpartumDeviceError")
    
    
    static let NotiAudioIsChange = Notification.Name("NotiAudioIsChange")
}
