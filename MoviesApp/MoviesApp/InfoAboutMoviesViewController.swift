


import UIKit

class InfoAboutMoviesViewController: UIViewController {
    
    var selectedMovie: InfoAboutSelectMovieModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a scroll view
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .black
        view.addSubview(scrollView)
        
        // Create a container view
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        
        // Create a movie title label
        
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Copperplate", size: 25)
        titleLabel.text = "\(selectedMovie?.title ?? "no")"
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        // Create an image view
        let imageView = UIImageView()
        guard let url = URL(string: selectedMovie?.poster ?? "") else { return }
        imageView.loadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                imageView.image = image
            }
        }
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageView)
        
        // Create a blurView
//        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
//        blurView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.addSubview(blurView)
//        // Create a blurWidthConstraint
//        let blurWidthConstraint = blurView.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1/5)
//        NSLayoutConstraint.activate([blurWidthConstraint])
        
        // Create a stack view
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 100
        stackView.alignment = .center
        containerView.addSubview(stackView)
        
        // Create a rating label
        let ratingLabel = UILabel()
        ratingLabel.text = "\(selectedMovie?.imdbRating ?? "0.0") / 10"
        ratingLabel.textAlignment = .center
        ratingLabel.textColor = .white
        ratingLabel.layer.cornerRadius = 10
        ratingLabel.layer.borderColor = UIColor.red.cgColor
        ratingLabel.layer.borderWidth = 1.0 // Толщина рамки
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        
//        let starImage = UIImage(systemName: "star.fill")
//        let starImageView = UIImageView(image: starImage)
//        starImageView.tintColor = .red
//        starImageView.contentMode = .scaleAspectFit
//        starImageView.translatesAutoresizingMaskIntoConstraints = false
//        ratingLabel.addSubview(starImageView)
        
        // Create a year label
        let yearLabel = UILabel()
        yearLabel.text = "\(selectedMovie?.year ?? "0")"
        yearLabel.textAlignment = .center
        yearLabel.textColor = .white
        yearLabel.layer.cornerRadius = 10
        yearLabel.layer.borderColor = UIColor.red.cgColor
        yearLabel.layer.borderWidth = 1.0 // Толщина рамки
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add labels to the stack view
        stackView.addArrangedSubview(ratingLabel)
        stackView.addArrangedSubview(yearLabel)
        
        // Create a plot label
        let plotLabel = UILabel()
        plotLabel.text = selectedMovie?.plot
        plotLabel.numberOfLines = 0
        plotLabel.textAlignment = .center
        plotLabel.textColor = .white
        plotLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(plotLabel)
        
        let runTimeLabel = UILabel()
        runTimeLabel.backgroundColor = .blue
        runTimeLabel.text = selectedMovie?.runtime
        runTimeLabel.numberOfLines = 1
        runTimeLabel.textAlignment = .center
        runTimeLabel.font = UIFont.systemFont(ofSize: 50)
        runTimeLabel.textColor = .white
        runTimeLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        runTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        runTimeLabel.sizeToFit()
        //blurView.contentView.addSubview(runTimeLabel)
    
        let genreLabel = UILabel()
        genreLabel.backgroundColor = .black
        genreLabel.text = selectedMovie?.genre
        genreLabel.numberOfLines = 1
        genreLabel.textAlignment = .center
        genreLabel.textColor = .white
        genreLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.sizeToFit()
        //blurView.contentView.addSubview(genreLabel)
      
     
        
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
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.height / 2 + 150),
            
//            blurView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
//            blurView.topAnchor.constraint(equalTo: imageView.topAnchor),
//            blurView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
//            blurWidthConstraint,
          
            
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            ratingLabel.widthAnchor.constraint(equalToConstant: 100),
            yearLabel.widthAnchor.constraint(equalToConstant: 100),
            
//            starImageView.widthAnchor.constraint(equalToConstant: 20),
//            starImageView.heightAnchor.constraint(equalToConstant: 20),
//            starImageView.trailingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: -5),
//            starImageView.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            
            plotLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            plotLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            plotLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            plotLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
}



     
        
  
   



        
