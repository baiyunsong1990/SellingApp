//
//  CollectionViewExp.swift
//  exchangeCalculator
//
//  Created by apple on 2016/12/11.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CollectionViewExp:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //collectionView = UICollectionView(frame: CGRect(x: 10, y: 40, width: 200, height: 200),collectionview)
        
        //let layout = UICollectionViewLayout()
        
        
        //collectionView.delegate = self
        //collectionView.dataSource = self
        
        let label=UILabel(frame: CGRect(x: 10, y: 40, width: 200, height: 40))
        label.text="aaaaaaaaaaaaa"
        label.isUserInteractionEnabled=true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        label.addGestureRecognizer(tapGesture)
        label.sizeToFit()
        print(label.bounds.maxX)
        print(label.frame.width)
        self.view.addSubview(label)
    }
    
    func tap(sender:UILabel?) {
        print(sender?.text ?? "0j")
        //print(sender.text ?? "00")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! MyCollectionViewCell
        print(indexPath.item)
        cell.myLabel.text = items[indexPath.item]
        //cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
}
