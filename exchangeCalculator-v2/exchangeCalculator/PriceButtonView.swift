//
//  PriceButtonView.swift
//  exchangeCalculator
//
//  Created by apple on 2016/12/12.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

@objc protocol PriceButtonViewDelegate: NSObjectProtocol {
    @objc optional func buttonDidTapped(button: PriceButtonView)
    @objc optional func buttonDidlongPressed(button: PriceButtonView)
}


class PriceButtonView:UIView {
    
    var textView = UITextField()
    
    var colorList = ColorList()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textView = UITextField(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: frame.size.width, height: frame.size.height)))
        textView.isEnabled = false
        textView.font = UIFont(name: "Snell Roundhand", size: 12)
        textView.textColor = colorList.itemBtnGrayColor
        addSubview(textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
