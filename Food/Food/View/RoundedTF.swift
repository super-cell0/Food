//
//  RoundedTF.swift
//  FoodPin
//
//  Created by 贝蒂小熊 on 2021/12/8.
//

import UIKit

class RoundedTF: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    //文字缩排
    //返回文本字段文本的绘图矩形
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    //返回文本字段占位符文本的绘图矩形
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    //返回用于显示可编辑文本的矩形
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    //建立圆角
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.systemGray5.cgColor
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
    }



}
