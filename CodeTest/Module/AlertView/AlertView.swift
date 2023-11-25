//
//  Alert.swift
//  AngelDoctor
//
//  Created by dsq on 2021/2/25.
//

import UIKit

public let alertTag = 10001


///确定的闭包
typealias AlertSureCompleteClosure = (() -> Void)
///有选择项的闭包
typealias AlertHandleCompleteClosure = ((_ compelete: Bool) -> Void)


//MARK: 警告框的使用
class AlertTool: NSObject {
    
    ///单个确认按钮的警告框
    @discardableResult
    class func alertTitle(supView: UIView? = UIApplication.shared.windows.first, title: String?, content: String?, textAlignment: NSTextAlignment = .left, sureTitle: String = "知道了" ,complete: AlertSureCompleteClosure?) -> AlertView {
       
        if let alert = supView?.viewWithTag(alertTag) {
            alert.removeFromSuperview()
        }

        let alertView = AlertView.init(title: title, content: content, textAlignment: textAlignment ,sureTitle: sureTitle , complete: complete)
        alertView.tag = alertTag
        alertView.show(supView: supView)
        
        return alertView
    }
    
    ///确认，取消按钮的警告框
    @discardableResult
    class func alertTitle(title: String?, content: String?, textAlignment: NSTextAlignment = .left , leftTitle: String = "取消", rightTitle: String = "确认", complete: AlertHandleCompleteClosure?) -> AlertView{
        
        if let alert = UIApplication.shared.windows.first?.viewWithTag(alertTag) {
            alert.removeFromSuperview()
        }

        let alertView = AlertView.init(title: title, content: content, textAlignment: textAlignment , leftTitle: leftTitle, rightTitle: rightTitle, complete: complete)
        alertView.tag = alertTag
        alertView.show()

        return alertView
    }
}



//MARK: 警告框
class AlertView: UIView {
    
    
    var shadowView: UIView = {
        let shadowView = UIView.init()
        shadowView.alpha = 0.56
        shadowView.backgroundColor = UIColor.init(r: 53, g: 46, b: 48)
        return shadowView
    }()
    
    //内容view
    var contentView: UIView = {
        let contentView = UIView.init()
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        return contentView
    }()
    
    private var bottomView: UIView = {
        let bottomView = UIView.init()
        return bottomView
    }()
    
 
    fileprivate var sureClosure: AlertSureCompleteClosure?
    
    fileprivate var handleClosure: AlertHandleCompleteClosure?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    
    convenience init(title: String?, content: String?, textAlignment: NSTextAlignment = .left , leftTitle: String = "取消", rightTitle: String = "确定", complete: AlertHandleCompleteClosure?) {
        self.init()
        
        setupView(title: title, content: content, textAlignment: textAlignment)
        
        handleClosure = complete
        
        //取消按钮
        let cancelBtn = createAlertBtn(title: leftTitle, titleColor: BackColor3)
        cancelBtn.tag = 0
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cancelBtn.addTarget(self, action: #selector(onClickHandleBtn(_:)), for: .touchUpInside)
        bottomView.addSubview(cancelBtn)
    
        //确定按钮
        let sureBtn = createAlertBtn(title: rightTitle, titleColor: ThemeColor)
        sureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        sureBtn.tag = 1
        sureBtn.addTarget(self, action: #selector(onClickHandleBtn(_:)), for: .touchUpInside)
        bottomView.addSubview(sureBtn)
        
        //分割线
        let curLineView = UIImageView.init()
        curLineView.backgroundColor = lineBgColor
        bottomView.addSubview(curLineView)
        
        cancelBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
        }
        
        sureBtn.snp.makeConstraints { (make) in
            make.left.equalTo(cancelBtn.snp.right)
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(cancelBtn.snp.width)
        }
        
        curLineView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(1)
        }
    }
    
    convenience init(title: String?, content: String?, textAlignment: NSTextAlignment = .left  , sureTitle: String = "知道了", complete: AlertSureCompleteClosure?) {
        self.init()
        
        setupView(title: title, content: content, textAlignment: textAlignment)
        
        sureClosure = complete
        
        let sureBtn = createAlertBtn(title: sureTitle)
        sureBtn.addTarget(self, action: #selector(onClickSureBtn), for: .touchUpInside)
        bottomView.addSubview(sureBtn)
        sureBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(bottomView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(title: String?, content: String?, textAlignment: NSTextAlignment = .left){
        //阴影部分
        self.addSubview(self.shadowView)
        self.shadowView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }

        //内容画布
        //添加阴影部分
        let layerShadowView = UIView.init()
        self.addSubview(layerShadowView)
        layerShadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
        layerShadowView.layer.shadowRadius = 6
        layerShadowView.layer.shadowOpacity = 1
        layerShadowView.layer.shouldRasterize = true
        layerShadowView.layer.rasterizationScale = UIScreen.main.scale
        layerShadowView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(257)
        }

        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(257)
        }
        
        let titleLabel = UILabel.init()
        titleLabel.font = .systemFont(ofSize: 16,weight: .semibold)
        titleLabel.textColor = BackColor3
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        self.contentView.addSubview(titleLabel)
        titleLabel.text = title
        
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 3
        paraph.alignment = .center
        let attributes = [NSAttributedString.Key.paragraphStyle:paraph,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16,weight: .semibold),]
        let attr = NSAttributedString(string: titleLabel.text ?? "", attributes: attributes)
        titleLabel.attributedText = attr

        
        
        let contentLabel = UILabel.init()
        contentLabel.font = .systemFont(ofSize: 14)
        contentLabel.textColor = BackColor3
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = textAlignment

        self.contentView.addSubview(contentLabel)
        contentLabel.text = content
        
        let attributes1 = [NSAttributedString.Key.paragraphStyle:paraph,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),]
        let attr1 = NSAttributedString(string: contentLabel.text ?? "", attributes: attributes1)
        contentLabel.attributedText = attr1
        
        titleLabel.snp.makeConstraints { (make) in
//            make.centerX.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(26)
            make.right.equalTo(self.contentView).offset(-26)
            make.top.equalTo(self.contentView).offset(20)
        }
        

        
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalTo(self.contentView).offset(26)
            make.right.equalTo(self.contentView).offset(-26)
        }
        
        
        //分割线
        let lineView = UIImageView()
        lineView.backgroundColor = lineBgColor
        self.contentView.addSubview(lineView)
        
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.contentView)
            make.top.equalTo(contentLabel.snp.bottom).offset(18)
            make.height.equalTo(1)
        }
        
        
        if content != nil {
            lineView.snp.makeConstraints { (make) in
                make.left.right.equalTo(self.contentView)
                make.top.equalTo(contentLabel.snp.bottom).offset(15)
                make.height.equalTo(1)
            }
        }else {
            lineView.snp.makeConstraints { (make) in
                make.left.right.equalTo(self.contentView)
                make.top.equalTo(titleLabel.snp.bottom).offset(15)
                make.height.equalTo(1)
            }
        }
        
        
        
        self.contentView.addSubview(self.bottomView)
        self.bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.contentView)
            make.top.equalTo(lineView.snp.bottom)
            make.height.equalTo(50)
        }
        
    }
    
    fileprivate func createAlertBtn(title: String?, titleColor: UIColor = UIColor.init(r: 33, g: 33, b: 33)) -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        btn.setTitleColor(titleColor, for: .normal)
        btn.setTitle(title, for: .normal)
        btn.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .normal)
        btn.setBackgroundImage(UIImage.imageWithColor(UIColor.init(r: 0, g: 0, b: 0, a: 0.1)), for: .highlighted)
        return btn
    }
    
    
    //MARK:
    @objc func onClickSureBtn() {
        
        if (self.sureClosure != nil) {
            self.sureClosure!()
        }
        
        self.close()
        
    }
    
    @objc func onClickHandleBtn(_ btn: UIButton) {
        if self.handleClosure != nil {
            self.handleClosure!(btn.tag == 1)
        }
        self.close()
    }
    
    //MARK: 公有方法
    
    //展示
    func show(supView: UIView? = nil) {
        
        var window = supView
        if window == nil {
            window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        }
        if window != nil {
            window?.addSubview(self)
            self.snp.makeConstraints { (make) in
                make.edges.equalTo(window!)
            }
            self.animationAlert(view: self.contentView)
        }
    }
    
    //关闭
    func close() {
        
        UIView.animate(withDuration: 0.15) {
            self.shadowView.alpha = 0.01
            self.contentView.alpha = 0.01
        } completion: { result in
            self.removeFromSuperview()
        }
        
    }
    
    
    
    ///展示弹出动画
    func animationAlert(view: UIView) {
         let popAnimation = CAKeyframeAnimation.init(keyPath: "transform")
        popAnimation.duration = 0.25
        let values =  [NSValue.init(caTransform3D: CATransform3DMakeScale(0.01, 0.01, 0.01)),
//                       NSValue.init(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)),
//                       NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)),
                       NSValue.init(caTransform3D: CATransform3DIdentity),
        ]
        popAnimation.values = values
        
//        popAnimation.keyTimes = [0.0,0.5,0.75,1]
        
        popAnimation.timingFunctions = [
            CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut),
            CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut),
            CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        ]
        
        view.layer.add(popAnimation, forKey: nil)
    }
    
    ///移除所有的警告框
    private func removeAllAlert() {
        
    }
}

