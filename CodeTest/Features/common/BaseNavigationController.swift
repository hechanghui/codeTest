//
//  BaseNavigationController.swift
//   
//
//  Created by  hech on 2021/1/19.
//

import UIKit

class BaseNavigationController: UINavigationController,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {

        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            leftButton.contentHorizontalAlignment = .left
            leftButton.setImage(UIImage(named: "backIcon"), for: .normal)
            leftButton.addTarget(self, action:  #selector(self.goBack), for: .touchUpInside)
//            leftButton.backgroundColor = UIColor.red
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
            self.interactivePopGestureRecognizer?.delegate = self;
        }
        super.pushViewController(viewController, animated: animated)
    }

    
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer == self.interactivePopGestureRecognizer) {
            return self.viewControllers.count > 1
        }
        return true
    }
    
    
    @objc func goBack()  {
        self.popViewController(animated: true)
    }
    

    
}
