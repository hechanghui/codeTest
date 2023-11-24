//
//  ADLog.swift
//  AngelDoctor
//
//  Created by dsq on 2021/1/16.
//

import Foundation
import Alamofire


func alertView_show(_ title: String, message: String? = nil) {
    
    guard let message = message else {
        return
    }
    
    let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
    alertVC.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
    
    UIViewController.currentNavController()?.navigationController?.present(alertVC, animated: true, completion: nil)
    
}

func alertActionSheet(titleList: [String], handler: ((_ index: Int) -> Void)?) {
    if titleList.count == 0 {
        return
    }
    let alertController = UIAlertController(title: nil, message: nil,
                                            preferredStyle: .actionSheet)
    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
   
    alertController.addAction(cancelAction)
    for (index, title)in titleList.enumerated() {
        let photoAction = UIAlertAction(title: title, style: .default) { (alertAction) in
            guard let handler = handler else { return }
            handler(index)
        }
        alertController.addAction(photoAction)
    }
    UIViewController.currentNavController()?.navigationController?.present(alertController, animated: true, completion: nil)
}

/// 主线程执行
func dispatch_async_safely_main_queue(_ block: @escaping () -> ()){
    dispatch_async_safely_queue(DispatchQueue.main, block)
}


func dispatch_async_safely_queue(_ queue: DispatchQueue, _ block: @escaping ()->()) {
    if queue === DispatchQueue.main && Thread.isMainThread{
        block()
    } else {
        queue.async {
            block()
        }
    }
}

/// GCD延时加载
func dispatch_main_after(after: Double, _ block: @escaping () -> ()){
    DispatchQueue.main.asyncAfter(deadline: .now() + after) {
        block()
    }
}

//
///// 普通的网络请求
//func requestUrl(url: String, block: @escaping (_ dict: Dictionary<String, Any>?) -> ()){
//
//    Alamofire.request(url, method: .post).responseJSON { (response) in
//            guard let result = response.result.value else {
//                debugPrint(response.result.error!)
//                return
//            }
//            block(result as? Dictionary<String, Any> ?? nil)
//        }
//}

///获取当前的delegate
//func getAppDelegate() -> AppDelegate {
//   return UIApplication.shared.delegate as! AppDelegate
//}




/// 适配宽度
func getFitWidth(_ value: CGFloat) -> CGFloat {
    let widthScale = UIScreen.main.bounds.width / 375
    return widthScale * value
}

/// 适配高度
func getFitHigh(_ value: CGFloat) -> CGFloat {
    let heightScale = UIScreen.main.bounds.height / 667.0
    return heightScale * value
}

/// 字体自适应
public func FitFont(_ font: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: font * UIScreen.main.bounds.width / 375.0)
}



func dispatchTimer(timeInterval: Double, repeatCount: Int, handler: @escaping (DispatchSourceTimer?, Int) -> Void) {
    
    if repeatCount <= 0 {
        return
    }
    let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
    var count = repeatCount
    timer.schedule(deadline: .now(), repeating: timeInterval)
    timer.setEventHandler {
        count -= 1
        DispatchQueue.main.async {
            handler(timer, count)
        }
        if count == 0 {
            timer.cancel()
        }
    }
    timer.resume()
    
}
