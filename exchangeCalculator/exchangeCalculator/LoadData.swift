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
    
    func load(category:String) {
        //获取数据库实例
        db = SQLiteDB.sharedInstance
        //如果表还不存在则创建表（其中uid为自增主键）
        let result = db.execute(sql: "create table if not exists tb_category(id integer primary key,category varchar(30),item_name varchar(100),item_price varchar(10))")
        //print(result)
        
        clearTable(table_name: "tb_category")
        
        let cInfo = CommodityInfo()
        let new_category = category.replacingOccurrences(of: " ", with: "%20")
        let commodityArr:NSArray=cInfo.getInfo("http://www.chemistwarehouse.com.au/search?searchtext=fish%20oil&searchmode=allwords")
        //print(commodityArr)

        
        
        for i in 0..<commodityArr.count{
            
            let commodity:NSArray=commodityArr[i] as! NSArray
            
            insertData(category: category, item_name: commodity[0] as! String, item_price: commodity[1] as! String)
            
        }

    }
    
    func createTable() {
        
    }
    
    func insertData(category:String,item_name:String,item_price:String) {
        //插入数据库，这里用到了esc字符编码函数，其实是调用bridge.m实现的
        let sql = "insert into tb_category(category,item_name,item_price) values('\(category)','\(item_name)','\(item_price)')"
        //print("sql: \(sql)")
        //通过封装的方法执行sql
        let result = db.execute(sql: sql)
        print(result)
    }
    
    func clearTable(table_name:String){
        let result = db.execute(sql: "delete from \(table_name)")
        print(result)
    }
    
    func deleteTable(table_name:String) {
        let result = db.execute(sql: "drop table \(table_name)")
        print(result)
    }
}
