//
//  ViewCheckout.swift
//  exchangeCalculator
//
//  Created by apple on 2016/12/10.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class ViewCheckout: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource{
    
    var selectedItem:NSMutableArray = []
    
    let SCREEN_WIDTH = Int(UIScreen.main.bounds.width)
    let SCREEN_HEIGHT = Int(UIScreen.main.bounds.height)
    
    let H_MARGIN = 20 //横向间距
    let V_MARGIN = 5  //纵向间距
    let CELL_HEIGHT:CGFloat = 44.0
    
    var lblPrice = UILabel()
    var itemTableView = UITableView()
    
    var db:SQLiteDB!
    
    var data:[[String:Any]] = []
    var rate:Double = 0.0
    var price_total = 0.0
    
    var name = "" //用户名
    
    var colorList = ColorList()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = colorList.greyColor

        let itemView = UIView(frame: CGRect(x: 0, y: 70, width: SCREEN_WIDTH, height: 29))
        itemView.backgroundColor = UIColor.white
        let itemDescription = UILabel(frame: CGRect(x: H_MARGIN, y: V_MARGIN, width: SCREEN_WIDTH, height: 20))
        itemDescription.text = "商品结算"
        itemDescription.font = UIFont.systemFont(ofSize: 14)
        itemView.addSubview(itemDescription)
        
        itemTableView.dataSource=self
        itemTableView.delegate=self
        itemTableView.rowHeight = UITableViewAutomaticDimension
        itemTableView.frame = CGRect(x: 0, y: 101, width: SCREEN_WIDTH, height: Int(CGFloat(SCREEN_HEIGHT)*0.3))
        itemTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.view.addSubview(itemView)
        self.view.addSubview(itemTableView)
        
        let priceView = UIView(frame: CGRect(x: 0, y: Int(itemTableView.frame.height)+110, width: SCREEN_WIDTH, height: 60))
        priceView.backgroundColor = UIColor.white
        
        let eRate = ExchangeRate()
        rate = eRate.getCurrentRate()
        
        let lblRate = UILabel(frame: CGRect(x: H_MARGIN, y: V_MARGIN, width: SCREEN_WIDTH-H_MARGIN*2, height: 20))
        
        lblRate.text = "汇率:"+String(format: "%.2f", rate)
        lblRate.font = UIFont.systemFont(ofSize: 14)
        priceView.addSubview(lblRate)
        
        lblPrice.frame = CGRect(x: H_MARGIN, y: 35, width: SCREEN_WIDTH-H_MARGIN*2, height: 20)

        lblPrice.textColor = UIColor(red: 216/255, green: 74/255, blue: 19/255, alpha: 1.0)
        lblPrice.textAlignment = NSTextAlignment.center
        priceView.addSubview(lblPrice)
        
        self.view.addSubview(priceView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: UIBarButtonItemStyle.plain, target: self, action: #selector(Pay(sender:)))
        
        let userView = UIView(frame: CGRect(x: 0, y: Int(itemTableView.frame.height)+180, width: SCREEN_WIDTH, height: 29))
        userView.backgroundColor = UIColor.white
        
        let lblUser = UILabel(frame: CGRect(x: H_MARGIN, y: V_MARGIN, width: SCREEN_WIDTH, height: 19))
        lblUser.text = "用户信息"
        lblUser.font = UIFont.systemFont(ofSize: 14)
        lblUser.backgroundColor = UIColor.white
        userView.addSubview(lblUser)
        self.view.addSubview(userView)
        
        db = SQLiteDB.sharedInstance
        data = db.query(sql: "select * from tb_user")
        let picker = UIPickerView(frame: CGRect(x: 0, y: Int(itemTableView.frame.height)+211, width: SCREEN_WIDTH, height: Int(Double(SCREEN_HEIGHT)*0.28)))
        
        picker.dataSource = self
        picker.delegate = self
        
        picker.selectRow(0,inComponent:0,animated:true)
        picker.backgroundColor = UIColor.white

        self.view.addSubview(picker)

    }
    
    func Pay(sender:UIBarButtonItem?) {
        
        db = SQLiteDB.sharedInstance
        
        /*viewController.arrItem = selectedItem
        viewController.price = lblPrice.text!
        self.hidesBottomBarWhenPushed = false
        self.navigationController?.pushViewController(viewController, animated: true)*/
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return data.count //总共n行
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.sizeToFit()
        label.text = data[row]["name"] as! String?
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        name = data[pickerView.selectedRow(inComponent: 0)]["name"] as! String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedItem.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return CELL_HEIGHT
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "td")
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let lblInfo = UILabel(frame: CGRect(x: H_MARGIN, y: V_MARGIN, width: SCREEN_WIDTH-H_MARGIN*2, height: 20))
        let arr:NSArray = selectedItem[indexPath.row] as! NSArray
        lblInfo.font = UIFont.systemFont(ofSize: 14)
        lblInfo.text = String(describing: arr[0])+":"+String(describing: arr[1])+"*"+String(describing: arr[2])
        lblInfo.textColor = colorList.itemTextColor
        lblInfo.lineBreakMode = NSLineBreakMode.byClipping;
        lblInfo.numberOfLines = 0
        lblInfo.sizeToFit()
        
        let d:Double = Double(arr[1] as! Int)
        
        let c = (arr[2] as! NSString).replacingOccurrences(of: "$", with: "")
        
        price_total += d*(c as NSString).doubleValue
        lblPrice.text = "总价:" + String(format: "%.2f", price_total*rate) + " RMB"
        
        cell.addSubview(lblInfo)
        
        return cell
    }
}
