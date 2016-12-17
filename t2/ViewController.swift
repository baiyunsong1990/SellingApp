

import UIKit

class ViewController: UIViewController {
    
    let reuseIdentifier = "CellId"
    
    lazy var collectionView: UICollectionView = {[weak self] in
        let layout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: (self?.view.frame)!, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
}

