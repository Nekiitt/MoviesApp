//
//  MosaicCell.swift
//  MoviesApp
//
//  Created by Dubrouski Nikita on 21.07.23.
//

import UIKit

class MosaicCell: UICollectionViewCell {
    
    static let identifer = "kMosaicCollectionViewCell"

    var imageView = UIImageView()
    var assetIdentifier: String?
    var title: String = ""

    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.clipsToBounds = true
        self.autoresizesSubviews = true
        imageView.frame = self.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(imageView)
        
        // Use a random background color.
        let redColor = CGFloat(arc4random_uniform(255)) / 255.0
        let greenColor = CGFloat(arc4random_uniform(255)) / 255.0
        let blueColor = CGFloat(arc4random_uniform(255)) / 255.0
        self.backgroundColor = UIColor(red: redColor, green: greenColor, blue: blueColor, alpha: 1.0)
        
        print(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: SearchModel) {
        title = model.title
//        imageView = model.poster
       }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        assetIdentifier = nil
    }
}
