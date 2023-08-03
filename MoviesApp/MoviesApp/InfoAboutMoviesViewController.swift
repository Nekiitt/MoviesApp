//
//  InfoAboutMoviesViewController.swift
//  MoviesApp
//
//  Created by Dubrouski Nikita on 3.08.23.
//


import UIKit

class InfoAboutMoviesViewController: UIViewController {
    
    var movieDetails: MovieDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a scroll view
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
      
        view.addSubview(scrollView)
        
        // Add constraints for the scroll view to fill the view
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Create a label
        let label = UILabel()
        label.text = "Your label text"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(label)
        
        // Add constraints for the label
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            label.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Create an image view
        let imageView = UIImageView()
        imageView.image = UIImage(named: "your_image_name")
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        
        // Add constraints for the image view
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.5)
        ])
    }
    
    
}
