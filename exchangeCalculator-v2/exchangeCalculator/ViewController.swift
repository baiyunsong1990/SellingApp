//
//  ViewController.swift
//  exchangeCalculator
//
//  Created by apple on 2016/12/9.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var db:SQLiteDB!
    
    var data:[[String:Any]] = [] //数据库数据（名称，价格）
    var commodityArr:NSMutableArray = []  //网上数据（图片，价格）
    var imgPath:[String] = []
    
    let SCREEN_WIDTH = Int(UIScreen.main.bounds.width)
    let SCREEN_HEIGHT = Int(UIScreen.main.bounds.height)
    
    let CELL_HEIGHT:CGFloat = 76.0  //table单元格大小
    let IMG_SIZE = 60
    
    var buttonView = UIView()
    let myTableView = UITableView()
    let btnCheckout = UIButton()
    
    var quantityArr:[Int] = []  //商品数量
    var priceArr:[String] = []  //商品价格
    
    var seperator:[Int] = []  //不同分类的起始index
    var seperatorIndex = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //用户信息：姓名，电话，地址-->数据库
        let searchbar = UISearchBar(frame: CGRect(x: 40, y: 0, width: SCREEN_WIDTH-120, height: 40))
        let leftItem = UIBarButtonItem(customView: searchbar)
        self.navigationItem.leftBarButtonItem = leftItem
        
        //head size
        let headSize = 73
        //button size
        let buttonW = SCREEN_WIDTH/3
        let buttonH = 40
        
        let categoryArr = ["美容保健","母婴产品","日常保健","女性保健","奶粉系列","杂项"]
        
        //分类导航
        buttonView = UIView(frame: CGRect(x: 0, y: headSize, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        for i in 0...1 {
            for j in 0...2 {
            let button = UIButton(frame: CGRect(x:j * (2 + SCREEN_WIDTH/3), y: i*(buttonH+2), width:buttonW, height: buttonH))

            button.tag = j+i*3
            button.setTitle(categoryArr[j+i*3], for:UIControlState.normal)
            button.setTitleColor(UIColor.white, for: UIControlState.normal)

            button.setTitleColor(UIColor.blue, for: UIControlState.highlighted)
            button.setBackgroundImage(UIImage.init(named: "blue"), for: UIControlState.normal)
            button.setBackgroundImage(UIImage.init(named: "blue_selected"), for: UIControlState.selected)
            button.addTarget(self, action: #selector(changeItemView(sender:)), for: .touchUpInside)
            
            buttonView.addSubview(button)
            }
        }
        self.view.addSubview(buttonView)
        
        myTableView.dataSource=self
        myTableView.delegate=self
        myTableView.rowHeight = UITableViewAutomaticDimension
        myTableView.frame = CGRect(x: 10, y: 170, width: SCREEN_WIDTH-30, height: SCREEN_HEIGHT-230)
        self.view.addSubview(myTableView)
        
        //let loadData = LoadData()
        //loadData.deleteTable(table_name: "tb_category")
        
        /*let allCategorylist = SubCategory()
         for category:String in categoryArr {
         let subCategory = allCategorylist.getSubCategory(category: category) //一级分类数组
         for sub in subCategory{ //二级分类数组
         loadData.loadItem(category:category,sub_category: sub) //商品信息写入数据库
         
         let cInfo = CommodityInfo()
         let new_sub = sub.replacingOccurrences(of: " ", with: "%20")
         commodityArr.add(cInfo.getInfo("http://www.chemistwarehouse.com.au/search?searchtext="+new_sub+"&searchmode=allwords"))
            
         
         }
         }*/
        
        db = SQLiteDB.sharedInstance

        let allCategorylist = SubCategory()
        var count = 0
        for i in 0..<categoryArr.count {
            let subCategory = allCategorylist.getSubCategory(category: categoryArr[i])
            seperator.append(count)
            for sub in subCategory{ //二级分类数组
                let cInfo = CommodityInfo()
                let new_sub = sub.replacingOccurrences(of: " ", with: "%20")
                var cArr:NSArray = []
                cArr=(cInfo.getInfo("http://www.chemistwarehouse.com.au/search?searchtext="+new_sub+"&searchmode=allwords"))
                for c in cArr {
                    commodityArr.add(c)
                    count += 1
                }
                data.append(contentsOf:db.query(sql: "select * from tb_category where sub_category='\(sub)'"))
            }
        }
        for i in 0..<data.count {
            quantityArr.append(0)
            priceArr.append(data[i]["item_price"] as! String)
        }
        

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Checkout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(checkOut(sender:)))
        
        //数据库路径
        //let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        //print(filePath ?? "")
    }
    
    func changeItemView(sender:UIButton) {
        //切换按钮选中样式
        for v in buttonView.subviews {
            if(v.isMember(of: UIButton.self)) {
                (v as! UIButton).isSelected = false
            }
        }
        sender.isSelected = true
        
        //更新commodityArr数据
        commodityArr = []
        db = SQLiteDB.sharedInstance
        
        let allCategorylist = SubCategory()
        let subCategory = allCategorylist.getSubCategory(category: (sender.titleLabel?.text)!)
        
        for sub in subCategory{
            let cInfo = CommodityInfo()
            let new_sub = sub.replacingOccurrences(of: " ", with: "%20")
            var cArr:NSArray = []
            cArr=(cInfo.getInfo("http://www.chemistwarehouse.com.au/search?searchtext="+new_sub+"&searchmode=allwords"))
            for c in cArr {
                commodityArr.add(c)
            }
          
        }
        //更新起始index
        seperatorIndex = seperator[sender.tag]
        myTableView.reloadData()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commodityArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return CELL_HEIGHT
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let commodity:NSArray=commodityArr[indexPath.row] as! NSArray
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "td")
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if (commodity.count>0) {
            let myCell = CommodityCell(frame: CGRect(x: 0, y: 8, width: SCREEN_WIDTH-30, height: 65))
            
            /*let urlStr = NSURL(string: commodity[2] as! String)
             print(urlStr)
             let imgData = NSData(contentsOf: urlStr! as URL)
             print(imgData)
             let image = UIImage(data: imgData! as Data)
             print(image)
             myCell.commodityImg = UIImageView(image: image)*/
            
            myCell.lblCommodityName.text = data[indexPath.row+seperatorIndex]["item_name"] as! String?
            myCell.lblCommodityName.tag = indexPath.row + 5000
            myCell.lblCommodityName.sizeToFit()
            
            myCell.priceView.frame = CGRect(x: IMG_SIZE, y: Int(myCell.lblCommodityName.frame.height+5), width: SCREEN_WIDTH-IMG_SIZE-30, height: Int(CELL_HEIGHT-16))
            
            myCell.btnPriceFromWeb.setTitle(commodity[1] as? String, for: UIControlState.normal)
            myCell.btnPriceFromWeb.tag = indexPath.row + 100
            
            myCell.btnPriceFromWeb.addTarget(self, action: #selector(selectPrice(sender:)), for: .touchUpInside)
            
            myCell.btnPriceFromDatabase.textView.text = data[indexPath.row+seperatorIndex]["item_price"] as! String?
            myCell.btnPriceFromDatabase.tag = indexPath.row + 1000
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(tapGesture:)))
            myCell.btnPriceFromDatabase.addGestureRecognizer(tapGesture)
            
            myCell.btnMinus.tag = indexPath.row + 10000
            myCell.btnMinus.addTarget(self, action: #selector(changeQuantity(sender:)), for: .touchUpInside)
            myCell.lblQuantity.tag = indexPath.row + 11000
            myCell.lblQuantity.text = String(quantityArr[indexPath.row+seperatorIndex])
            myCell.btnAdd.tag = indexPath.row + 12000
            myCell.btnAdd.addTarget(self, action: #selector(changeQuantity(sender:)), for: .touchUpInside)
            
            let urlStr = NSURL(string: String(describing: commodity[2]))
            let imgData = NSData(contentsOf: urlStr! as URL)
            let image = UIImage(data: imgData! as Data)
            let commodityImg = UIImageView(image: image)
            commodityImg.frame = CGRect(x: 0,y: 8,width: IMG_SIZE,height: IMG_SIZE)
            
            cell.addSubview(commodityImg)
            
            cell.addSubview(myCell)
        }
        
        return cell
    }
    
    func selectPrice(sender:UIButton?) {
        sender?.setTitleColor(UIColor.init(red: 6/255, green: 122/255, blue: 190/255, alpha: 1.0),for: .normal)
        sender?.titleLabel?.font = UIFont(name: "Snell Roundhand", size: 16)
        let tag:NSInteger = (sender?.tag)!%100+1000
        
        let btnView:PriceButtonView = self.myTableView.viewWithTag(tag) as! PriceButtonView
        btnView.textView.textColor = UIColor.init(red: 117/255, green: 137/255, blue: 149/255, alpha: 1.0)
        btnView.textView.font = UIFont(name: "Snell Roundhand", size: 12)
        
        let tag2:NSInteger = (sender?.tag)!%100+5000
        let nameView:UILabel = self.myTableView.viewWithTag(tag2) as! UILabel
        
        priceArr[(sender?.tag)!-100] = (sender?.titleLabel?.text)!
        
        if (btnView.textView.isEnabled == true) {
            let sql="update tb_category set item_price='\(btnView.textView.text)' where item_name='\(nameView.text)'"
            print(sql)
            let re = db.execute(sql: sql)
            print(re)
        }
        
        btnView.textView.isEnabled = false
    }
    
    func changeQuantity(sender:UIButton?) {
        var tag:NSInteger = 10000
        var label = UILabel()
        if (sender?.titleLabel?.text == "+") {
            tag = (sender?.tag)!-1000
            label = self.myTableView.viewWithTag(tag) as! UILabel
            label.text = String(Int(label.text!)! + 1)
        } else {
            tag = (sender?.tag)!+1000
            label = self.myTableView.viewWithTag(tag) as! UILabel
            if (!(label.text=="0")) {
            label.text = String(Int(label.text!)! - 1)
            }
        }
        quantityArr[tag-11000+seperatorIndex] = Int(label.text!)!
    }
    
    func tap(tapGesture: UITapGestureRecognizer) {
        let sender:PriceButtonView = tapGesture.view as! PriceButtonView
        
        sender.textView.textColor = UIColor(red: 6/255, green: 122/255, blue: 190/255, alpha: 1.0)
        sender.textView.font = UIFont(name: "Snell Roundhand", size: 16)
        sender.textView.isEnabled = false
        
        let tag:NSInteger = (sender.tag)%1000+100
        let btnView:UIButton = self.myTableView.viewWithTag(tag) as! UIButton
        btnView.setTitleColor(UIColor.init(red: 117/255, green: 137/255, blue: 149/255, alpha: 1.0),for: .normal)
        btnView.titleLabel?.font = UIFont(name: "Snell Roundhand", size: 12)
        
        priceArr[sender.tag-1000] = (sender.textView.text)!
    }
    
    func checkOut(sender:UIBarButtonItem?) {
        let secondView = ViewCheckout()
        var arrItem:NSMutableArray = []

        for i in 0..<data.count {
            if (quantityArr[i]>0) {
                arrItem.add([data[i]["item_name"],quantityArr[i],priceArr[i]])
            }
        }

        secondView.selectedItem = arrItem
        self.hidesBottomBarWhenPushed = false
        self.navigationController?.pushViewController(secondView, animated: true)
    }
    
    func autoLabelHeight(with text:String , labelWidth: CGFloat ,attributes : [String : Any]) -> CGFloat{
        var size = CGRect()
        let size2 = CGSize(width: labelWidth, height: 0)//设置label的最大宽度
        size = text.boundingRect(with: size2, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes , context: nil);
        return size.size.height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: PriceButtonDelegate {
    func buttonDidTapped(button: PriceButton) {

        button.txtPrice?.textColor = UIColor.init(red: 6/255, green: 122/255, blue: 190/255, alpha: 1.0)
        button.txtPrice?.font = UIFont(name: "Snell Roundhand", size: 16)
        button.txtPrice?.isEnabled = false
        
        let tag:NSInteger = (button.tag)%1000+100
        let btnView:UIButton = myTableView.viewWithTag(tag) as! UIButton
        btnView.setTitleColor(UIColor.init(red: 117/255, green: 137/255, blue: 149/255, alpha: 1.0),for: .normal)
        btnView.titleLabel?.font = UIFont(name: "Snell Roundhand", size: 12)
        
    }
    func buttonDidlongPressed(button: PriceButton) {
        button.txtPrice?.isEnabled = true
        
    }
}

