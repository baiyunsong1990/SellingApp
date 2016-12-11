//
//  ViewS.swift
//  ProcurementServiceApp
//
//  Created by 白云松 on 10/12/16.
//  Copyright © 2016 redage. All rights reserved.
//

import UIKit

class ViewS: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let SCREEN_WIDTH = Int(UIScreen.main.bounds.width)
        let SCREEN_HEIGHT = Int(UIScreen.main.bounds.height)
        
        
        //search
        
        let search = UISearchBar(frame: CGRect(x: 0, y: 28, width: SCREEN_WIDTH, height: 44))
        self.view.addSubview(search)
        //head size
        let headSize = 73
        //button size
        let buttonW = SCREEN_WIDTH/3
        let buttonH = 40
        
        
        //button Line 1
        for i in 0...2 {
            let button = UIButton(frame: CGRect(x:0 + i * (2 + SCREEN_WIDTH/3), y: headSize, width:buttonW, height: buttonH))
            //button status normal
            button.tag = i
            button.setTitle("美容保健", for:UIControlState.normal)
            button.setTitleColor(UIColor.white, for: UIControlState.normal)
            //button status selected
            button.setTitleColor(UIColor.blue, for: UIControlState.highlighted)
            button.setBackgroundImage(UIImage.init(named: "blue"), for: UIControlState.normal)
            button.addTarget(self, action: #selector(clicked(sender:)), for: .touchUpInside)
            print(UIControlState.selected)
            
            self.view.addSubview(button)
            
        }
     
        
        
        //button 2 Line 2
        for i in 0...2{
            let button2 = UIButton(frame: CGRect(x:0 + i * (2 + SCREEN_WIDTH/3), y: 115, width:buttonW, height: buttonH))
            //button status normal
            button2.tag = 3 + i
            button2.setTitle("美容保健", for:UIControlState.normal)
            button2.setTitleColor(UIColor.white, for: UIControlState.normal)
            button2.setTitleShadowColor(UIColor.black, for: UIControlState.normal)
            //button status selected
            button2.setTitleColor(UIColor.blue, for: UIControlState.highlighted)
            button2.setBackgroundImage(UIImage.init(named: "blue"), for: UIControlState.normal)
            button2.addTarget(self, action: #selector(clicked(sender:)), for: .touchUpInside)
            print(UIControlState.selected)
            
            self.view.addSubview(button2)
            
        }
        
        // table view 
        
        let tabView = UITableView(frame: CGRect(x: 0, y: headSize + 2 * buttonH , width: SCREEN_WIDTH, height: 500), style: UITableViewStyle.plain)
        
        let tabViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        
        let cellLabel = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: Int(tabViewCell.bounds.height)))
        cellLabel.text = "Baiyunsong"
        
        // add label into cell
        tabViewCell.addSubview(cellLabel)
        //add cell into tableview
        tabView.addSubview(tabViewCell)
        
        
    
        
        self.view.addSubview(tabView)

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func clicked(sender:UIButton) {
        print(sender.state)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
