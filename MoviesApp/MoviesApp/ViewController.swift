//
//  ViewController.swift
//  MoviesApp
//
//  Created by Dubrouski Nikita on 21.07.23.
//
import UIKit

class ViewController: UIViewController {

    var myCollectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIView()
        view.backgroundColor = .white
        
        let mosaicLayout = MosaicLayout()
        myCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: mosaicLayout)// Add minimum line spacing
        
        myCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        myCollectionView?.backgroundColor = UIColor.white
        
        
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
        myCollectionView?.register(MosaicCell.self, forCellWithReuseIdentifier: MosaicCell.identifer)
        view.addSubview(myCollectionView ?? UICollectionView())
        self.view = view
        
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: MosaicCell.identifer, for: indexPath)
        
    
        return myCell
    }
}

extension ViewController: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       print("User tapped on item \(indexPath.row)")
    }
}
