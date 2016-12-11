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
    
    var data:[[String:Any]] = []
    var commodityArr:NSArray = []
    var imgPath:[String] = []
    
    let SCREEN_WIDTH = Int(UIScreen.main.bounds.width)
    let SCREEN_HEIGHT = Int(UIScreen.main.bounds.height)
    
    let CELL_HEIGHT:CGFloat = 76.0
    let IMG_SIZE = 60
    
    let myTableView = UITableView()
    let btnCheckout = UIButton()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //用户信息：姓名，电话，地址-->数据库
        
        
        myTableView.dataSource=self
        myTableView.delegate=self
        myTableView.rowHeight = UITableViewAutomaticDimension
        myTableView.frame = CGRect(x: 10, y: 10, width: SCREEN_WIDTH-30, height: SCREEN_HEIGHT-50)
        
        btnCheckout.frame = CGRect(x: 0, y: 70, width: SCREEN_WIDTH, height: 30)
        btnCheckout.setTitle("Checkout", for: UIControlState.normal)
        btnCheckout.titleLabel?.font = UIFont(name: "Snell Roundhand", size: 20)
        btnCheckout.backgroundColor = UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        btnCheckout.setTitleColor(UIColor.init(red: 6/255, green: 122/255, blue: 190/255, alpha: 1.0),for: .normal)
        btnCheckout.addTarget(self, action: #selector(checkOut(sender:)), for: .touchUpInside)
        
        //let loadData = LoadData()
        let category:String = "fish oil"

        //loadData.load(category: category)
        
        let cInfo = CommodityInfo()
        commodityArr = cInfo.getInfo("http://www.chemistwarehouse.com.au/search?searchtext=fish%20oil&searchmode=allwords")
        
        db = SQLiteDB.sharedInstance
        
        data = db.query(sql: "select * from tb_category where category='\(category)'")
        //db.execute(sql: "update tb_category set item_price='10' where item_name='Swisse Kids Fish Oil 50 Burstlets'")
        
        
        //let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        //print(filePath ?? "")
        
        
        //let eRate = ExchangeRate()
        //print(eRate.getCurrentRate())

        
        //let arr=UIFont.familyNames
        //print(arr)

        //self.view.addSubview(btnCheckout)
        self.view.addSubview(myTableView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Checkout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(checkOut(sender:)))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
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
        
        let myView = UIView(frame: CGRect(x: 0, y: 8, width: SCREEN_WIDTH-30, height: 65))
        
        let urlStr = NSURL(string: commodity[2] as! String)
        let imgData = NSData(contentsOf: urlStr! as URL)
        let image = UIImage(data: imgData! as Data)
        let commodityImg = UIImageView(image: image)
        commodityImg.frame = CGRect(x: 0,y: 0,width: IMG_SIZE,height: IMG_SIZE)
        
        let lblCommodityName = UILabel(frame:CGRect(x: IMG_SIZE, y: 0, width: 400, height: 16))
        lblCommodityName.textAlignment = NSTextAlignment.left
        lblCommodityName.text = data[indexPath.row]["item_name"] as! String?
        lblCommodityName.textColor=UIColor.init(red: 20/255, green: 90/255, blue: 149/255, alpha: 1.0)
        lblCommodityName.font=UIFont(name: "Hoefler Text", size: 12)
        lblCommodityName.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        lblCommodityName.tag = indexPath.row + 5000
        
        
        let priceView = UIView(frame: CGRect(x:IMG_SIZE,y:24,width:400,height:40))
        
        let btnPriceFromWeb = UIButton(frame:CGRect(x: 0, y: 0, width: 60, height: 16))
        btnPriceFromWeb.setTitle(commodity[1] as! String, for: UIControlState.normal)
        btnPriceFromWeb.titleLabel?.font = UIFont(name: "Snell Roundhand", size: 16)
        btnPriceFromWeb.contentHorizontalAlignment = UIControlContentHorizontalAlignment(rawValue: 0)!
        btnPriceFromWeb.setTitleColor(UIColor.init(red: 6/255, green: 122/255, blue: 190/255, alpha: 1.0),for: .normal)
        btnPriceFromWeb.tag = indexPath.row + 100
        btnPriceFromWeb.addTarget(self, action: #selector(selectPrice(sender:)), for: .touchUpInside)
        
        let btnPriceFromDatabase = PriceButton(frame: CGRect(x: 65, y: 0, width: 50, height: 16))
        btnPriceFromDatabase.delegate = self
        btnPriceFromDatabase.txtPrice?.text = data[indexPath.row]["item_price"] as! String?
        btnPriceFromDatabase.tag = indexPath.row + 1000
        
        let btnMinus = UIButton(frame: CGRect(x: 150, y: 0, width: 15, height: 15))
        btnMinus.setTitle("-", for: UIControlState.normal)
        btnMinus.titleLabel?.font = UIFont(name: "Hoefler Text", size: 15)
        btnMinus.setTitleColor(UIColor.init(red: 6/255, green: 122/255, blue: 190/255, alpha: 1.0),for: .normal)
        btnMinus.addTarget(self, action: #selector(changeQuantity(sender:)), for: .touchUpInside)
        btnMinus.tag = indexPath.row + 10000
        
        let textQuantity = UITextField(frame: CGRect(x: 165, y: 0, width: 30, height: 15))
        textQuantity.text = "0"
        textQuantity.font = UIFont.systemFont(ofSize: 12)
        textQuantity.borderStyle = UITextBorderStyle.roundedRect
        textQuantity.keyboardType = UIKeyboardType.numberPad
        textQuantity.textAlignment = NSTextAlignment.right
        textQuantity.tag = indexPath.row + 11000
        //print(indexPath.row)
        
        let btnAdd = UIButton(frame: CGRect(x: 200, y: 0, width: 15, height: 15))
        btnAdd.setTitle("+", for: UIControlState.normal)
        btnAdd.titleLabel?.font = UIFont(name: "Hoefler Text", size: 15)
        btnAdd.setTitleColor(UIColor.init(red: 6/255, green: 122/255, blue: 190/255, alpha: 1.0),for: .normal)
        btnAdd.addTarget(self, action: #selector(changeQuantity(sender:)), for: .touchUpInside)
        btnAdd.tag = indexPath.row + 12000
        
        priceView.addSubview(btnPriceFromWeb)
        priceView.addSubview(btnPriceFromDatabase)
        priceView.addSubview(btnMinus)
        priceView.addSubview(textQuantity)
        priceView.addSubview(btnAdd)
        
        myView.addSubview(commodityImg)
        myView.addSubview(lblCommodityName)
        myView.addSubview(priceView)
        cell.addSubview(myView)
        
        
        return cell
    }
    
    func selectPrice(sender:UIButton?) {
        sender?.setTitleColor(UIColor.init(red: 6/255, green: 122/255, blue: 190/255, alpha: 1.0),for: .normal)
        sender?.titleLabel?.font = UIFont(name: "Snell Roundhand", size: 16)
        let tag:NSInteger = (sender?.tag)!%100+1000
        
        let btnView:PriceButton = myTableView.viewWithTag(tag) as! PriceButton
        btnView.txtPrice?.textColor = UIColor.init(red: 117/255, green: 137/255, blue: 149/255, alpha: 1.0)
        btnView.txtPrice?.font = UIFont(name: "Snell Roundhand", size: 12)
        btnView.buttonState = ".Off"
        
        let tag2:NSInteger = (sender?.tag)!%100+5000
        let nameView:UILabel = myTableView.viewWithTag(tag2) as! UILabel
        
        if (btnView.txtPrice?.isEnabled == true) {
        var sql="update tb_category set item_price='\(btnView.txtPrice?.text)' where item_name='\(nameView.text)'"
        //print(sql)
        let re = db.execute(sql: sql)
            print(re)
        }
        
        btnView.txtPrice?.isEnabled = false
    }
    
    func changeQuantity(sender:UIButton?) {
        let btn:UIButton = sender!
        let tag:NSInteger = btn.tag

        if (btn.titleLabel?.text ?? "???" == "+") {
            let txtview:UITextField = myTableView.viewWithTag(tag-1000) as! UITextField
            txtview.text = String(NSInteger(txtview.text!)!+1)
            let btnMinus2:UIButton = myTableView.viewWithTag(tag-2000) as! UIButton
            btnMinus2.isEnabled = true
            
        } else {
            let txtview:UITextField = myTableView.viewWithTag(tag+1000) as! UITextField
            txtview.text = String(NSInteger(txtview.text!)!-1)
            if(NSInteger(txtview.text!)==0) {
                btn.isEnabled = false
            }
        }
        
    }
    
    func checkOut(sender:UIBarButtonItem?) {
        let secondView = ViewCheckout()
        var arrItem:NSMutableArray = []
        for i in 0...7{
            let txt:UITextField = myTableView.viewWithTag(i+11000) as! UITextField
            let label:UILabel = myTableView.viewWithTag(i+5000) as! UILabel
            let btnFromWeb:UIButton = myTableView.viewWithTag(i+100) as! UIButton
            let btnFromDatabase:PriceButton = myTableView.viewWithTag(i+1000) as! PriceButton
            var price:String = ""
            if (btnFromDatabase.buttonState == ".On") {
                price = btnFromDatabase.txtPrice?.text ?? ""
            } else {
                price = btnFromWeb.titleLabel?.text ?? ""
            }
            //print(price)
            print(txt.text)
            if (!(txt.text=="0")) {
                arrItem.add([label.text,String(NSInteger(txt.text!)!),price])
            }
        }
        

        secondView.selectedItem = arrItem
        self.hidesBottomBarWhenPushed = false
        self.navigationController?.pushViewController(secondView, animated: true)
        //self.present(secondView, animated: true, completion: nil)
        //self.performSegue(withIdentifier: "Checkout", sender: self)
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Checkout"{
            let controller = segue.destination as! ViewCheckout
            controller.itemString = "aaa"
        }
    }*/
    
    func autoLabelHeight(with text:String , labelWidth: CGFloat ,attributes : [String : Any]) -> CGFloat{
        var size = CGRect()
        let size2 = CGSize(width: labelWidth, height: 0)//设置label的最大宽度
        size = text.boundingRect(with: size2, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes , context: nil);
        return size.size.height
    }
    
    /*func flatButtonPressed(_ sender: AnyObject) {
        print("flatButtonPressed")
        
    }*/
    
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



