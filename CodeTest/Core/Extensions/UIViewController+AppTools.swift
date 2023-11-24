//
//  UIViewController+AppTools.swift
//   
//
//  Created by  hech on 2021/1/13.
//

import UIKit

extension UIViewController {
    
    class func currentNavController() -> UIViewController? {
        guard let window = UIApplication.shared.delegate?.window else {
            return nil
        }
        var vc = window?.rootViewController
        while vc != nil {
            if let tabVC = vc as? UITabBarController {
                vc = tabVC.selectedViewController
                continue
            } else if let navVC = vc as? UINavigationController {
                vc = navVC.topViewController
                return vc
            } else {
                break
            }
        }
        return  vc
    }
    
    ///移除当前控制器
    public func removeControllerForNavigation() {
        
        //进入下个页面后，将该控制器删除
        var vcArr = self.navigationController?.viewControllers
        if vcArr == nil { return }
        for (i, vc) in vcArr!.enumerated() {
            if vc == self {
                vcArr?.remove(at: i)
                break
            }
        }
        self.navigationController?.viewControllers = vcArr!
    }
}

