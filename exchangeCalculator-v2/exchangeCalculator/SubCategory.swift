//
//  SubCategory.swift
//  exchangeCalculator
//
//  Created by apple on 2016/12/16.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation

class SubCategory {
    func getSubCategory(category:String) -> [String] {
        var arr = [String]()
        switch category {
        case "美容保健":
            arr.append("swisse grape seed")
            arr.append("swisse hair skin nail")
            //arr.append("swisse orgainc spirulina") //none
            arr.append("swisse women vitamin")
            arr.append("healthy care garcinia cambogia")
        case "母婴产品":
            arr.append("ostelin vitamin D kids liquid")
            arr.append("ostelin vitamin D calcium kids chewable")
            arr.append("bio island milk calcium")
            arr.append("bio island cod liver fish oil")
            arr.append("bio island DHA")
            arr.append("bio island zinc") //none
            arr.append("bio island DHA pregnancy")
            arr.append("blackmores pregnancy breastfeeding gold")
            arr.append("floradix iron form")
        case "日常保健":
            arr.append("blackmores dourless fish oil")
            arr.append("healthy care lecithin")
            arr.append("healthy care propolis")
            arr.append("blackmores glucosamine sulfate")
            arr.append("blackmores celery")
            arr.append("blackmores sugar balance")
            arr.append("blackmores VC") //none
            arr.append("swisse ultiboost enzyme Q10")
            arr.append("healthy care coenzyme Q10") //??
            arr.append("swisse ultiboost liver detox")
        case "女性保健":
            arr.append("swisse ultiboost high strength cranberry")
            arr.append("blackmores evening primrose oil")
            arr.append("swisse ultiboost menopause balance") //??
        default:
            break
        }
        return arr
    }
}
