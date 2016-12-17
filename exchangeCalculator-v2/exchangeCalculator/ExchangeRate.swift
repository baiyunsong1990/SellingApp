//
//  ExchangeRate.swift
//  priceCalcuator
//
//  Created by apple on 16/12/4.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation

class ExchangeRate{
    func getCurrentRate() -> Double{
        var rate:String=""
        
        let myURLString = "http://free.currencyconverterapi.com/api/v3/convert?q=AUD_CNY&compact=y&callback=sampleCallback"
        
        let myURL = URL(string: myURLString)
        var myHTMLString = ""
        
        do {
            myHTMLString = try String(contentsOf: myURL!, encoding: String.Encoding.utf8)
            
        } catch {
            print("Error : \(error)")
        }
        
        //print(myHTMLString)
        
        let myPattern="val\":[0-9]*.[0-9]*"
        
        let s = Regex(myPattern: myPattern, HTMLString: myHTMLString).result[0]
        rate = (s as AnyObject).substring(from: 5)
        
        /*do{
            let regex = try NSRegularExpression(pattern: myPattern, options: [])
            let nsString = myHTMLString as NSString

            let res = regex.matchesInString(myHTMLString, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, myHTMLString.characters.count))

            for checkingRes in res {
                var s:NSString = nsString.substringWithRange(checkingRes.range)
                rate=s.substringFromIndex(5)
            }

        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
        }*/
        
        //let myData : NSData = NSData(contentsOfURL: myURL!)!
        //print(myData)
        
        /*do {
            let json = try NSJSONSerialization.JSONObjectWithData(myData, options:.AllowFragments)
            let stations = json["AUD_CNY"] as! String
                print(stations)
                /*for station in stations {
                    
                    if let name = station["val"] as? String {
                        
                        print(name)
                        rate=name
                        
                    }*/
                
            //let val: String = json.objectForKey("AUD_CNY") as! String
            //rate=val
            
        }catch {
            
        }*/
        
        return Double(rate)!
    }
}
