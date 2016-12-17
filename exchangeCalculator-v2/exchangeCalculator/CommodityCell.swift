//
//  CommodityCell.swift
//  exchangeCalculator
//
//  Created by apple on 2016/12/12.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit


class CommodityCell: UIView{
    
    let SCREEN_WIDTH = Int(UIScreen.main.bounds.width)
    let SCREEN_HEIGHT = Int(UIScreen.main.bounds.height)
    
    let IMG_SIZE = 60
    
    var myView = UIView()
    var commodityImg = UIImageView()
    var lblCommodityName = UILabel()
    var priceView = UIView()
    var btnPriceFromWeb = UIButton()
    var btnPriceFromDatabase = PriceButtonView()
    var btnAdd = UIButton()
    var lblQuantity = UILabel()
    var btnMinus = UIButton()
    var stepper = UIStepper()
    
    var arrPrice = [String]()
    var quantityArr = [Int]()
    
    var colorList = ColorList()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //let urlStr = NSURL(string: getPath())
        //let imgData = NSData(contentsOf: urlStr! as URL)
        
        //commodityImg = UIImageView(image: image)
        commodityImg = UIImageView(frame: CGRect(x: 0,y: 0,width: IMG_SIZE,height: IMG_SIZE))
        
        lblCommodityName = UILabel(frame:CGRect(x: IMG_SIZE, y: 0, width: SCREEN_WIDTH-IMG_SIZE-30, height: 40))
        lblCommodityName.textAlignment = NSTextAlignment.left
        lblCommodityName.textColor = colorList.itemTextColor
        lblCommodityName.font=UIFont(name: "Hoefler Text", size: 12)
        lblCommodityName.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        lblCommodityName.lineBreakMode = NSLineBreakMode.byClipping;
        lblCommodityName.numberOfLines = 0
        
        priceView = UIView(frame: CGRect(x:IMG_SIZE,y:20,width:400,height:40))
        
        btnPriceFromWeb = UIButton(frame:CGRect(x: 0, y: 0, width: 60, height: 16))
        btnPriceFromWeb.titleLabel?.font = UIFont(name: "Snell Roundhand", size: 16)
        btnPriceFromWeb.contentHorizontalAlignment = UIControlContentHorizontalAlignment(rawValue: 0)!
        btnPriceFromWeb.setTitleColor(colorList.itemBtnColor,for: .normal)
        
        btnPriceFromDatabase = PriceButtonView(frame: CGRect(x: 60, y: 0, width: 60, height: 16))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPressGesture:)))
        btnPriceFromDatabase.addGestureRecognizer(longPressGesture)

        btnMinus = UIButton(frame: CGRect(x: 120, y: 0, width: 20, height: 20))
        btnMinus.setTitle("-", for: UIControlState.normal)
        btnMinus.setTitleColor((colorList.itemBtnColor),for: .normal)
        btnMinus.layer.borderColor = colorList.greyColor.cgColor
        btnMinus.layer.borderWidth = 1
 
        
        lblQuantity = UILabel(frame: CGRect(x: 139, y: 0, width: 80, height: 20))
        lblQuantity.font = UIFont.systemFont(ofSize: 12)
        lblQuantity.textAlignment = NSTextAlignment.center
        lblQuantity.layer.borderColor = colorList.greyColor.cgColor
        lblQuantity.layer.borderWidth = 1

        
        btnAdd = UIButton(frame: CGRect(x: 218, y: 0, width: 20, height: 20))
        btnAdd.setTitle("+", for: UIControlState.normal)
        btnAdd.setTitleColor(colorList.itemBtnColor,for: .normal)
        btnAdd.layer.borderColor = colorList.greyColor.cgColor
        btnAdd.layer.borderWidth = 1
        
        priceView.addSubview(btnPriceFromWeb)
        priceView.addSubview(btnPriceFromDatabase)
        priceView.addSubview(btnAdd)
        priceView.addSubview(lblQuantity)
        priceView.addSubview(btnMinus)
        
        addSubview(commodityImg)
        addSubview(lblCommodityName)
        addSubview(priceView)
        
    }
    
    func selectPrice(sender:UIButton?) {
        sender?.setTitleColor((colorList.itemBtnColor),for: .normal)
        sender?.titleLabel?.font = UIFont(name: "Snell Roundhand", size: 16)
        let tag:NSInteger = (sender?.tag)!%100+1000
        
        let btnView:PriceButtonView = self.viewWithTag(tag) as! PriceButtonView
        btnView.textView.textColor = colorList.itemBtnGrayColor
        btnView.textView.font = UIFont(name: "Snell Roundhand", size: 12)
        
        let tag2:NSInteger = (sender?.tag)!%100+5000
        let nameView:UILabel = self.viewWithTag(tag2) as! UILabel
        
        if (btnView.textView.isEnabled == true) {
            let sql="update tb_category set item_price='\(btnView.textView.text)' where item_name='\(nameView.text)'"
            print(sql)

        }
        
        btnView.textView.isEnabled = false
    }
    
    func changeQuantity(sender:UIButton?) {
        var tag:NSInteger = 10000
        if (sender?.titleLabel?.text == "+") {
            tag = (sender?.tag)!-1000
            let label:UILabel = self.viewWithTag(tag) as! UILabel
            label.text = String(Int(label.text!)! + 1)
        } else {
            tag = (sender?.tag)!+1000
            let label:UILabel = self.viewWithTag(tag) as! UILabel
            label.text = String(Int(label.text!)! - 1)
        }
        quantityArr[tag-10000] = Int(stepper.value)
    }
    
    func tap(tapGesture: UITapGestureRecognizer) {
        let sender:PriceButtonView = tapGesture.view as! PriceButtonView
        
        sender.textView.textColor = colorList.itemBtnColor
        sender.textView.font = UIFont(name: "Snell Roundhand", size: 16)
        sender.textView.isEnabled = false
        
        let tag:NSInteger = (sender.tag)%1000+100
        let btnView:UIButton = self.viewWithTag(tag) as! UIButton
        btnView.setTitleColor(colorList.itemBtnGrayColor,for: .normal)
        btnView.titleLabel?.font = UIFont(name: "Snell Roundhand", size: 12)
    }
    
    func longPress(longPressGesture: UILongPressGestureRecognizer) {
        if (longPressGesture.state == .began) {
            let sender:PriceButtonView = longPressGesture.view as! PriceButtonView
            sender.textView.isEnabled = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

