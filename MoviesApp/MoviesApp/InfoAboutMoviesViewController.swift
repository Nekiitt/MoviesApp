


import UIKit

class InfoAboutMoviesViewController: UIViewController {
    
    var selectedMovie: InfoAboutSelectMovieModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a scroll view
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        view.addSubview(scrollView)
        
        // Create a container view
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        
        // Create a movie title label
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.text = "\(selectedMovie?.title ?? "no")"
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        // Create an image view
        let imageView = UIImageView()
        imageView.image = UIImage(named: selectedMovie?.poster ?? "")
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageView)
        
        // Create a stack view
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 100
        stackView.alignment = .center
        containerView.addSubview(stackView)
        
        // Create a rating label
        let ratingLabel = UILabel()
        ratingLabel.text = "\(selectedMovie?.rated ?? "0.0") / 10"
        ratingLabel.textAlignment = .center
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Create a year label
        let yearLabel = UILabel()
        yearLabel.text = "\(selectedMovie?.year ?? "0")"
        yearLabel.textAlignment = .center
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add labels to the stack view
        stackView.addArrangedSubview(ratingLabel)
        stackView.addArrangedSubview(yearLabel)
        
        // Create a plot label
        let plotLabel = UILabel()
        plotLabel.text = selectedMovie?.plot
        plotLabel.numberOfLines = 0
        plotLabel.textAlignment = .center
        plotLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(plotLabel)
        
        // Set constraints for the views
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            ratingLabel.widthAnchor.constraint(equalToConstant: 100),
            yearLabel.widthAnchor.constraint(equalToConstant: 100),
            
            plotLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            plotLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            plotLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            plotLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
}
