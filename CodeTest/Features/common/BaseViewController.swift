//
//  BaseViewController.swift
//   
//
//  Created by  hech on 2021/1/19.
//

import UIKit

class BaseViewController: UIViewController {

    //给tableView用的参数
    //TODO BaseTableViewController的封装
//    var pageNum = 1
//    var nodataView = ADNodataView.loadFromNib()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.color(hexString: "#FFFFFF")


        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.shadowColor = UIColor.clear
            navBarAppearance.backgroundColor = UIColor.clear
            self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        } else {
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.barTintColor = .clear
        }
        
//        self.view.backgroundColor = .white
 
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    
    
    
    deinit {
        debugPrint( "deinit + \(self.classForCoder) ")
    }


}



extension BaseViewController {
    
    /// 设置右边导航栏
    public func setNavBarRightTitle(_ title: NSString, titleFont: UIFont = .systemFont(ofSize: 16), titleColor: UIColor? = UIColor.gray){
        let textSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont])
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: textSize.width + 1, height: 44)
        btn.setTitle(title as String, for: .normal)
        btn.setTitleColor(titleColor, for: .normal)
        btn.titleLabel?.font = titleFont
        btn.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
    }
    
    /// 设置右边导航栏图片
    public func setNavBarRightImageName(_ imageName: String){
        var image = UIImage.init(named: imageName)
        image = image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: image, style: .done, target: self, action: #selector(rightButtonAction))
    }
    
    /// 设置左边导航栏图片
    public func setNavBarLeftImageName(_ imageName: String){
        var image = UIImage.init(named: imageName)
        image = image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: image, style: .done, target: self, action: #selector(leftButtonAction))
    }
    
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
            
    }
    
    //子类实现
    @objc func rightButtonAction() {
        
    }
    //子类实现
    @objc func leftButtonAction(){
        
    }
    
    
    func setTitleColor(color : UIColor){
        let navigationBarAppearance = self.navigationController?.navigationBar.standardAppearance
        let titleTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: color]
        navigationBarAppearance?.titleTextAttributes = titleTextAttributes
        
        // 应用设置
        self.navigationController?.navigationBar.standardAppearance = navigationBarAppearance ?? UINavigationBarAppearance()
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        self.navigationController?.navigationBar.compactAppearance = navigationBarAppearance
    }
    
    
    
    func setupSearchBarView(_ frame : CGRect = CGRect(x: 0, y: 3, width: SCREEN_WIDTH , height: 30)) {
        
        
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 44))
        leftButton.contentHorizontalAlignment = .left
        leftButton.setImage(UIImage(named: "backIcon"), for: .normal)
        leftButton.addTarget(self, action:  #selector(self.goBack), for: .touchUpInside)
//            leftButton.backgroundColor = UIColor.red
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
//        self.searchBarView = SQSearchBarView.init(isHideCancelBtn: true)
//        self.searchBarView.frame = CGRect(x: 0, y: 3, width: SCREEN_WIDTH, height: 30)
//        self.searchBarView.setSearchPlaceholder("搜索城市名")
//        self.searchBarView.setSearchColor( UIColor.color(hexString: "#F8F8F7"))
//        self.searchBarView.delegate = self
//        self.searchBarView.setSearchrightMarginX(10)
//        self.navigationItem.titleView = self.searchBarView
        
        
        
    }
    

   
}
