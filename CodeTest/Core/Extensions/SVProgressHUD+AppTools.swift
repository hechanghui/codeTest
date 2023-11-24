//
//  SVProgressHUD+AppTools.swift
//  doctorOnCloud
//
//  Created by 乐骄 on 2022/9/20.
//

import UIKit
import SVProgressHUD

extension SVProgressHUD {
    
    class func showProgress(progress: Float, info: String?) {
        SVProgressHUD.specialSetting()
        SVProgressHUD.showProgress(progress, status: info)
    }
    
    class func show(dismissDelay: TimeInterval) {
        SVProgressHUD.normalSetting()
        SVProgressHUD.show()
        SVProgressHUD.dismiss(withDelay: dismissDelay) {
            SVProgressHUD.customSetting()
        }
    }
    
    class func showSuccess(info: String?, dismissDelay: TimeInterval) {
        guard let str = info, str.count > 0 else {
            return
        }
        SVProgressHUD.dismiss()
        SVProgressHUD.normalSetting()
        SVProgressHUD.showSuccess(withStatus: info)
        SVProgressHUD.dismiss(withDelay: dismissDelay) {
            SVProgressHUD.customSetting()
        }
    }
    
    /// 自定义
    class func showError(info: String?, dismissDelay: TimeInterval) {
        guard let str = info, str.count > 0 else {
            return
        }
        SVProgressHUD.dismiss()
        SVProgressHUD.normalSetting()
        SVProgressHUD.showError(withStatus: info)
        SVProgressHUD.dismiss(withDelay: dismissDelay) {
            SVProgressHUD.customSetting()
        }
    }
    
    class func showInfo(info: String?, dismissDelay: TimeInterval) {
        guard let str = info, str.count > 0 else {
            return
        }
        SVProgressHUD.dismiss()
        SVProgressHUD.normalSetting()
        SVProgressHUD.setImageViewSize(CGSize(width: 0, height: -12))
        SVProgressHUD.showInfo(withStatus: info)
        SVProgressHUD.dismiss(withDelay: dismissDelay) {
            SVProgressHUD.customSetting()
        }
    }
    
    
    
    class func showWarnInfo(info: String?, dismissDelay: TimeInterval) {
        guard let str = info, str.count > 0 else {
            return
        }
        SVProgressHUD.dismiss()
        SVProgressHUD.normalSetting()
        SVProgressHUD.showInfo(withStatus: info)
        SVProgressHUD.dismiss(withDelay: dismissDelay) {
            SVProgressHUD.customSetting()
        }
    }
    
    
    
    class func showLoading(info:String?) {
  
        SVProgressHUD.dismiss()
        SVProgressHUD.setMinimumSize(CGSize(width: 120, height: 120))
        SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
        SVProgressHUD.setBackgroundColor(.black.withAlphaComponent(0.76))
        SVProgressHUD.setForegroundColor(.white)
        SVProgressHUD.show(withStatus: info ?? "加载中")
    }
    
    /// 上传头像等待
    class func showWaitingStart(info:String?) {
        guard let str = info, str.count > 0 else {
            return
        }
        SVProgressHUD.dismiss()
        SVProgressHUD.setMinimumSize(CGSize(width: 135, height: 135))
        SVProgressHUD.setImageViewSize(CGSize(width: 39, height: 39))
        SVProgressHUD.setBackgroundColor(.black.withAlphaComponent(0.76))
        SVProgressHUD.setForegroundColor(.white)
        SVProgressHUD.show(withStatus: str)
    }
    
    /// 上传头像等待完成
    class func showWaitingEnd(info:String?, dismissDelay: TimeInterval) {
        guard let str = info, str.count > 0 else {
            return
        }
        SVProgressHUD.setMinimumSize(CGSize(width: 120, height: 120))
        SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
        SVProgressHUD.setBackgroundColor(.black.withAlphaComponent(0.76))
        SVProgressHUD.setForegroundColor(.white)
        SVProgressHUD.showSuccess(withStatus: str)
        SVProgressHUD.dismiss(withDelay: dismissDelay) {
            SVProgressHUD.customSetting()
        }
    }
    
    
    class func customSetting() {
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setBackgroundColor(.clear)
//        SVProgressHUD.setForegroundColor(UIColor("#FC7301"))
        SVProgressHUD.setRingNoTextRadius(14)
        SVProgressHUD.setRingRadius(14)
        SVProgressHUD.setRingThickness(3.5)
        SVProgressHUD.setMinimumSize(UIScreen.main.bounds.size)
        SVProgressHUD.setDefaultMaskType(.clear)
    }
    
    class func normalSetting() {
        SVProgressHUD.setDefaultStyle(.dark)
//        SVProgressHUD.setImageViewSize(CGSize(width: 0, height: -12))
        SVProgressHUD.setCornerRadius(6)
        SVProgressHUD.setMinimumSize(.zero)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 15))
    }
    
    class func specialSetting() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setImageViewSize(.zero)
        SVProgressHUD.setCornerRadius(10)
        SVProgressHUD.setMinimumSize(CGSize(width: 50, height: 50))
        SVProgressHUD.setDefaultMaskType(.clear)
    }
    
    
    
}

extension Double {
    
    func roundTo(places: Int)->Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}


class Loading {
    
    class func show(info: String = "加载中"){
        SVProgressHUD.showLoading(info: info)
    }
    
    class func dismiss(){
        SVProgressHUD.dismiss()
    }
}
