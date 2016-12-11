//
//  ViewCheckout.swift
//  exchangeCalculator
//
//  Created by apple on 2016/12/10.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class ViewCheckout: UIViewController{
    
    var selectedItem:NSMutableArray = []
    
    let SCREEN_WIDTH = Int(UIScreen.main.bounds.width)
    let SCREEN_HEIGHT = Int(UIScreen.main.bounds.height)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        print(selectedItem)
        let y_unit = 25
        var price_total = 0.0
        
        let itemView = UIView(frame: CGRect(x: 40, y: 80, width: SCREEN_WIDTH-20, height: 20))
        
        for i in 0..<selectedItem.count {
            var lblInfo = UILabel(frame: CGRect(x: 0, y: i*y_unit, width: SCREEN_WIDTH-20, height: 20))
            let arr:NSArray = selectedItem[i] as! NSArray
            
            lblInfo.font = UIFont.systemFont(ofSize: 14)
            lblInfo.text = String(describing: arr[0])+"*"+String(describing: arr[1])
            
            let p:Double = (arr[1] as! NSString).doubleValue
            
            let c = (arr[2] as! NSString).replacingOccurrences(of: "$", with: "")
            print(c)
            price_total += p*(c as! NSString).doubleValue
            
            itemView.addSubview(lblInfo)
        }
        self.view.addSubview(itemView)
        
        let eRate = ExchangeRate()
        var rate = eRate.getCurrentRate()
        
        var lblRate = UILabel(frame: CGRect(x: 40, y: Int(itemView.bounds.height+10), width: SCREEN_WIDTH-20, height: 20))
        lblRate.text = "Exchange Rate:"+String(rate)
        self.view.addSubview(lblRate)
        
        var lblPrice = UILabel(frame: CGRect(x: 40, y: Int(itemView.bounds.height+30), width: SCREEN_WIDTH-20, height: 20))
        lblPrice.text = "Total price:"+String(describing: price_total*rate)
        self.view.addSubview(lblPrice)
    }
}
