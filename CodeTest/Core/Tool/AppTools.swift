//
//  AppTools.swift
//  doctorOnCloud
//
//  Created by 武汉乐骄 on 2022/9/30.
//

import UIKit
///获取当前的delegate
///
///


public let SCREEN_WIDTH = UIScreen.main.bounds.size.width
public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height



let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
//let statusBarHeight = UIApplication.shared.statusBarFrame.height

func getAppDelegate() -> AppDelegate {
   return UIApplication.shared.delegate as! AppDelegate
}


func keyWindow() -> UIWindow? {

        struct Static {
            /** @abstract   Save keyWindow object for reuse.
            @discussion Sometimes [[UIApplication sharedApplication] keyWindow] is returning nil between the app.   */
            static weak var keyWindow: UIWindow?
        }

        var originalKeyWindow: UIWindow?

        #if swift(>=5.1)
        if #available(iOS 13, *) {
            originalKeyWindow = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })
        } else {
            originalKeyWindow = UIApplication.shared.keyWindow
        }
        #else
        originalKeyWindow = UIApplication.shared.keyWindow
        #endif

        //If original key window is not nil and the cached keywindow is also not original keywindow then changing keywindow.
        if let originalKeyWindow = originalKeyWindow {
            Static.keyWindow = originalKeyWindow
        }

        //Return KeyWindow
        return Static.keyWindow
    
}
