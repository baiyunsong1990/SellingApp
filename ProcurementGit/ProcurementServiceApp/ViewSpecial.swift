//
//  ViewSpecial.swift
//  ProcurementServiceApp
//
//  Created by 白云松 on 11/12/16.
//  Copyright © 2016 redage. All rights reserved.
//

import UIKit

class ViewSpecial: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let SCREEN_WIDTH = Int(UIScreen.main.bounds.width)
        let SCREEN_HEIGHT = Int(UIScreen.main.bounds.height)
        
        let uiCollection = UICollectionView(frame: CGRect(x: 0, y: 28, width:SCREEN_WIDTH, height: 500))
        
        
        self.view.addSubview(uiCollection)
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

