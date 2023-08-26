//
//  FavoriteCell.swift
//  MoviesApp
//
//  Created by Dubrouski Nikita on 26.08.23.
//


import UIKit

final class FavoriteCell: UICollectionViewCell {
    
    static let identifer = "FavoriteCell"

    private let loaderView = UIActivityIndicatorView(style: .medium)
    private var isLoading = false
    
    var imageView = UIImageView()
    var assetIdentifier: String?
    var poster: String = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLoaderView()
        self.clipsToBounds = true
        self.autoresizesSubviews = true
        imageView.frame = self.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(imageView)
        self.layer.cornerRadius = 10
        self.backgroundColor = .gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLoaderView() {
            contentView.addSubview(loaderView)
            loaderView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                loaderView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                loaderView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
            loaderView.hidesWhenStopped = true
        }
    
    func configure(model: InfoAboutSelectMovieModel) {
            poster = model.poster
            isLoading = true
            loaderView.startAnimating() // Показываем индикатор загрузки
            
            guard let url = URL(string: poster) else { return }
            imageView.loadImage(from: url) { [weak self] image in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.loaderView.stopAnimating() // Прячем индикатор загрузки
                    self?.imageView.image = image
                }
            }
        }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            isLoading = false
            loaderView.stopAnimating()
            imageView.image = nil
        }
}
