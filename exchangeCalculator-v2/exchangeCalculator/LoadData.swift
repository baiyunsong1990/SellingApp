//
//  LoadData.swift
//  priceCalcuator
//
//  Created by apple on 2016/12/6.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation

class LoadData  {
    
    var db:SQLiteDB!
    
    func loadItem(category:String,sub_category:String) {

        db = SQLiteDB.sharedInstance

        db.execute(sql: "create table if not exists tb_category(id integer primary key,category varchar(30),sub_category varchar(50),item_name varchar(100),item_price varchar(10))")
        
        let cInfo = CommodityInfo()
        let new_category = sub_category.replacingOccurrences(of: " ", with: "%20")
        let commodityArr:NSArray=cInfo.getInfo("http://www.chemistwarehouse.com.au/search?searchtext="+new_category+"&searchmode=allwords")

        
        for i in 0..<commodityArr.count{
            
            let commodity:NSArray=commodityArr[i] as! NSArray
            
            insertData(category: category, sub_category: sub_category, item_name: commodity[0] as! String, item_price: commodity[1] as! String)
            
        }

    }
    
    func loadUser() {
        db = SQLiteDB.sharedInstance
        //如果表还不存在则创建表（其中uid为自增主键）
        db.execute(sql: "create table if not exists tb_user(id integer primary key,name varchar(30),phone varchar(15),address varchar(100))")

        var sql = "insert into tb_user(name,phone,address) values('bbb','042222222','Kelvin Grove')"
        db.execute(sql: sql)
        //通过封装的方法执行sql
        //let result = db.execute(sql: sql)
        //print(result)
    }
    
    func loadOrder(info:NSMutableArray) {
        db = SQLiteDB.sharedInstance
        db.execute(sql: "create table if not exists tb_order(id integer primary key,user varchar(30),item varchar(50),quantity integer(4),price decimal(8,2)")
        
        //var sql = "insert into tb_order(user,item,quantity,price) values('"+info[0]+"','"+info[1]+"','"+info[2]+"','"+info[3]+"')"
        //db.execute(sql:sql)
    }
    
    func insertData(category:String,sub_category:String,item_name:String,item_price:String) {
        //插入数据库，这里用到了esc字符编码函数，其实是调用bridge.m实现的
        let sql = "insert into tb_category(category,sub_category,item_name,item_price) values('\(category)','\(sub_category)','\(item_name)','\(item_price)')"
        //print("sql: \(sql)")
        //通过封装的方法执行sql
        let result = db.execute(sql: sql)
        print(result)
    }
    
    func clearTable(table_name:String){
        db = SQLiteDB.sharedInstance
        let result = db.execute(sql: "delete from \(table_name)")
        print(result)
    }
    
    func deleteTable(table_name:String) {
        db = SQLiteDB.sharedInstance
        let result = db.execute(sql: "drop table \(table_name)")
        print(result)
    }
}
