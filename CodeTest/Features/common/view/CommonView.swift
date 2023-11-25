//
//  CommonButton.swift
//  doctorOnCloud
//
//  Created by 武汉乐骄 on 2022/9/29.
//

import UIKit

class CommonButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setStyle()
    }

    
    
    //默认样式
    func setStyle(_ cornerRadius : CGFloat = 20,_ font : CGFloat = 16){
        self.setBackgroundImage(UIImage.imageWithColor(ThemeColor), for: .normal)
        self.setBackgroundImage(UIImage.imageWithColor(UIColor.color(hexString: "#FF7252",alpha: 0.4)), for: .disabled)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.titleLabel?.font = UIFont.systemFont(ofSize: font)
        self.setTitleColor(UIColor.white, for: .normal)
    }
    
    //弱展示样式
    func setSubStyle(_ cornerRadius : CGFloat = 20,_ font : CGFloat = 16){
        self.setBackgroundImage(UIImage.imageWithColor(UIColor.color(hexString: "#FFEEEA")), for: .normal)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.titleLabel?.font = UIFont.systemFont(ofSize: font)
        self.setTitleColor(ThemeColor, for: .normal)
    }
    
    
    //线框样式
    func setLineStyle(_ cornerRadius : CGFloat = 20,_ font : CGFloat = 16){
        self.setBackgroundImage(UIImage.imageWithColor(UIColor.color(hexString: "#FFFFFF")), for: .normal)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = ThemeColor.cgColor
        self.titleLabel?.font = UIFont.systemFont(ofSize: font)
        self.setTitleColor(ThemeColor, for: .normal)
    }
    
    
    //弱线框样式
    func setSubLineStyle(_ cornerRadius : CGFloat = 20,_ font : CGFloat = 16){
        self.setBackgroundImage(UIImage.imageWithColor(UIColor.color(hexString: "#FFFFFF")), for: .normal)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = BackColor3.cgColor
        self.titleLabel?.font = UIFont.systemFont(ofSize: font)
        self.setTitleColor(BackColor3, for: .normal)
    }
    
    
    
    //警告线框样式
    func setUnableStyle(_ cornerRadius : CGFloat = 20,_ font : CGFloat = 16){
        self.setBackgroundImage(UIImage.imageWithColor(ViewSubBgColor), for: .normal)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.titleLabel?.font = UIFont.systemFont(ofSize: font)
        self.setTitleColor(BackColor9, for: .normal)
    }
    
    
    
    func setSeletStyle(_ cornerRadius : CGFloat = 16,_ font : CGFloat = 16){
        self.backgroundColor = ThemeColor
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.titleLabel?.font = UIFont.systemFont(ofSize: font)
        self.setTitleColor(UIColor.white, for: .selected)
        self.setTitleColor(BackColor3, for: .selected)
        self.setBackgroundImage(UIImage.imageWithColor(ThemeColor), for: .selected)
        self.setBackgroundImage(UIImage.imageWithColor(ViewSubBgColor), for: .normal)
    }
}

class CommonLabel : UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setStyle()
    }

    
    
    //默认样式
    func setStyle(_ cornerRadius : CGFloat = 20,_ font : CGFloat = 16){
        self.textColor = BackColor3
        self.font = FontHeadline3
        self.numberOfLines = 0
        self.textAlignment = .center
    }
}

