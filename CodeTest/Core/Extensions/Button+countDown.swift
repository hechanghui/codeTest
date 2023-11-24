//
//  Button+countDown.swift
//
//
//  Created by hech on 2021/3/12.
//

import UIKit


extension UIButton {

    //倒计时启动
    func countDown(count: Int){
        var codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())

        //倒计时开始，禁止点击事件
        isEnabled = false
        
        var remainingCount: Int = count {
            willSet {
                setTitle("重新获取\(newValue)s", for: .disabled)
                
                if newValue <= 0 {
                    setTitle("获取验证码", for: .normal)
                }
            }
        }
        
        if codeTimer.isCancelled {
            codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())

        }
        
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.schedule(deadline: .now(), repeating: .seconds(1))
        //
        codeTimer.setEventHandler(handler: {
            //主线程更新ui
            DispatchQueue.main.async {
                remainingCount -= 1
                if remainingCount <= 0 {
                    self.isEnabled = true
                    codeTimer.cancel()
                }
            }
        })
        
        //启动时间源
        codeTimer.resume()
        
    }
    
    
    //取消倒计时
//    func countDownCancel() {
//        if !codeTimer.isCancelled {
//            codeTimer.cancel()
//        }
//        
//        //返回主线程
//        DispatchQueue.main.async {
//            self.isEnabled = true
//            if self.titleLabel?.text?.count != 0 {
//                self.setTitle("获取验证码", for: .normal)
//            }
//        }
//    }
    
}
