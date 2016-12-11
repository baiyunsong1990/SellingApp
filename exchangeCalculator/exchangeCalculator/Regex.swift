//
//  Regex.swift
//  priceCalcuator
//
//  Created by apple on 16/12/4.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation

class Regex {
    
    var result:[String]=[]
    
    init(myPattern:String,HTMLString:String){
        do{
            let regex = try NSRegularExpression(pattern: myPattern, options: [])
            let nsString = HTMLString as NSString
            let results = regex.matches(in: HTMLString,
                options: [], range: NSMakeRange(0, nsString.length))
            
            result = results.map { nsString.substring(with: $0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")

        }
    }
}
