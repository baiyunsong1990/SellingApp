//
//  PriceButton.swift
//  priceCalcuator
//
//  Created by apple on 2016/12/9.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

/// 声明代理方法
@objc protocol PriceButtonDelegate: NSObjectProtocol {
    @objc optional func buttonDidTapped(button: PriceButton)
    @objc optional func buttonDidlongPressed(button: PriceButton)
}

class PriceButton: UIView {
    enum PriceButtonState {
        case On
        case Off
    }
    
    // 设置代理属性
    var delegate: PriceButtonDelegate?
    
    /// 内容标签
    var txtPrice: UITextField?

    var buttonState: NSString = ".Off"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /// 内容标签
        txtPrice = UITextField(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: frame.size.width, height: frame.size.height)))
        txtPrice?.isEnabled = false
        txtPrice?.font = UIFont(name: "Snell Roundhand", size: 12)
        txtPrice?.textColor = UIColor.init(red: 117/255, green: 137/255, blue: 149/255, alpha: 1.0)

        addSubview(txtPrice!)
        
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(tapGesture:)))
        addGestureRecognizer(tapGesture)
        // 添加长按手势
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPressGesture:)))
        addGestureRecognizer(longPressGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
// MARK: - 点击与长按的实现部分
extension PriceButton {
    func tap(tapGesture: UITapGestureRecognizer) {
        buttonState = ".On"
        delegate?.buttonDidTapped?(button: self)
    }
    func longPress(longPressGesture: UILongPressGestureRecognizer) {
        if longPressGesture.state == .began {
            delegate?.buttonDidlongPressed?(button: self)
        }
    }
}
