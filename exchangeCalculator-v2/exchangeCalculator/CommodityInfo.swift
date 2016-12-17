//
//  CommodityInfo.swift
//  priceCalcuator
//
//  Created by apple on 16/12/4.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation

class CommodityInfo{
    
    let ITEM_ONE_PAGE = 24
    
    func getInfo(_ url:String) -> NSArray {
        
        var commodityArr:NSMutableArray = []
        let myURLString = url
        
        let myURL = URL(string: myURLString)
        
        var myHTMLString = ""
        
        //do..try..catch异常处理
        do {
            myHTMLString = try String(contentsOf: myURL!, encoding: String.Encoding.utf8)
            
        } catch {
            print("Error : \(error)")
        }
        let patternPageCount="div class=\"pager-count\".*[0-9]+"
       
        // 获取总共的商品数，分页读取
        var pageNum = 1
        //print(Regex(myPattern: patternPageCount,HTMLString: myHTMLString).result.count)
        if (Regex(myPattern: patternPageCount,HTMLString: myHTMLString).result.count>0) {
        let itemAll = NSInteger((Regex(myPattern: patternPageCount,HTMLString: myHTMLString).result[0] as NSString).substring(from: 28))

        if (itemAll!%ITEM_ONE_PAGE == 0) {
            pageNum = itemAll!/ITEM_ONE_PAGE
        } else {
            pageNum = itemAll!/ITEM_ONE_PAGE + 1
        }
            }
        
        for i in 1...pageNum{
            var myURLString = url
            if (i>1) {
            myURLString = myURLString+"&page="+(String(i))
            }
            let myURL = URL(string: myURLString)
            
            //do..try..catch异常处理
            do {
                myHTMLString = try String(contentsOf: myURL!, encoding: String.Encoding.utf8)
                
            } catch {
                print("Error : \(error)")
            }
            
            
            let patternName = "<a class=\"product-container search-result\".*?title=(.*?)>"
            let patternPrice="<span class=\"Price\">.*[0-9]*"
            let patternImg = "img src=\"https://static.chemistwarehouse.com.au/ams/.*?jpg"
            
            
            var nameArr:[String]
            var priceArr:[String]
            var imgArr:[String]
            
            nameArr = Regex(myPattern: patternName,HTMLString: myHTMLString).result
            priceArr = Regex(myPattern: patternPrice,HTMLString: myHTMLString).result
            imgArr = Regex(myPattern: patternImg, HTMLString: myHTMLString).result
            
            for i in 0..<nameArr.count{
                let name = nameArr[i] as NSString
                let price = priceArr[i] as NSString
                let img = imgArr[i] as NSString
                let index:Int = name.range(of: "title").location
                //print (name.substringWithRange(NSMakeRange(index+8, name.length-index-11)))
                //print (img.substring(from: 9))
                let arr:NSMutableArray=[name.substring(with: NSMakeRange(index+8, name.length-index-11)),price.substring(from: 20),img.substring(from: 9)]
                commodityArr.add(arr)
                
            }
        }
        return commodityArr
    }
    
    /*func Regex(myPattern:String)->NSArray{
        do{
            let regex = try NSRegularExpression(pattern: myPattern, options: [])
            let nsString = myHTMLString as NSString
            let results = regex.matchesInString(myHTMLString,
                options: [], range: NSMakeRange(0, nsString.length))
            
            return results.map { nsString.substringWithRange($0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }*/
}
