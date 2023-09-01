


import UIKit
import RealmSwift

class InfoAboutMoviesViewController: UIViewController {
    
    let favoriteButton = UIButton()
    var selectedMovie: InfoAboutSelectMovieModel?
    
    let realmManager: RealmManagerProtocol = RealmManager()
    
    lazy var arrayMoviesIdDB: [MoviesIdDataBase] = {
        Array(realmManager.realm.objects(MoviesIdDataBase.self))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        stateFavoriteStar()
        let dr = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print(dr)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stateFavoriteStar()
    }
    
    func setupUi() {
        
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
        
        // Create a favoriteButton
        favoriteButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        
        let starImage = UIImage(systemName: "star")
        favoriteButton.setImage(starImage, for: .normal)
        
        let starFillImage = UIImage(systemName: "star.fill")
        favoriteButton.setImage(starFillImage, for: .selected)
        
        favoriteButton.tintColor = .yellow
        
        favoriteButton.imageView?.contentMode = .scaleAspectFit
        //favoriteButton.clipsToBounds = true
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(favoriteButton)
        
        
        
        
        
        // Create a stack view
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 50
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
        ratingLabel.font = UIFont(name: "Copperplate", size: 20)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Create a year label
        let yearLabel = UILabel()
        yearLabel.text = "\(selectedMovie?.released ?? "0")"
        yearLabel.textAlignment = .center
        yearLabel.textColor = .white
        yearLabel.layer.cornerRadius = 10
        yearLabel.layer.borderColor = UIColor.red.cgColor
        yearLabel.layer.borderWidth = 1.0 // Толщина рамки
        yearLabel.font = UIFont(name: "Copperplate", size: 20)
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add labels to the stack view
        stackView.addArrangedSubview(ratingLabel)
        stackView.addArrangedSubview(yearLabel)
        
        // Create a plot label
        let plotLabel = UILabel()
        plotLabel.text = selectedMovie?.plot
        plotLabel.numberOfLines = 0
        plotLabel.textAlignment = .justified
        plotLabel.textColor = .white
        plotLabel.font = UIFont(name: "Copperplate", size: 20)
        plotLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(plotLabel)
        
        let genreLabel = UILabel()
        genreLabel.text = selectedMovie?.genre
        genreLabel.numberOfLines = 1
        genreLabel.textAlignment = .center
        genreLabel.textColor = .white
        genreLabel.font = UIFont(name: "Copperplate", size: 20)
        genreLabel.layer.cornerRadius = 10
        genreLabel.layer.borderColor = UIColor.red.cgColor
        genreLabel.layer.borderWidth = 1.0 // Толщина рамки
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.sizeToFit()
        containerView.addSubview(genreLabel)
        
        let directorLabel = UILabel()
        directorLabel.text = "Director: \(selectedMovie?.director ?? "-")"
        directorLabel.numberOfLines = 1
        directorLabel.textAlignment = .left
        directorLabel.textColor = .white
        directorLabel.font = UIFont(name: "Copperplate", size: 20)
        directorLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(directorLabel)
        
        let actorsLabel = UILabel()
        actorsLabel.text = "Actors: \(selectedMovie?.actors ?? "-")"
        actorsLabel.numberOfLines = 0
        actorsLabel.textAlignment = .left
        actorsLabel.textColor = .white
        actorsLabel.font = UIFont(name: "Copperplate", size: 20)
        actorsLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(actorsLabel)
        
        let languageLabel = UILabel()
        languageLabel.text = "Language: \(selectedMovie?.language ?? "-")"
        languageLabel.numberOfLines = 0
        languageLabel.textAlignment = .left
        languageLabel.textColor = .white
        languageLabel.font = UIFont(name: "Copperplate", size: 20)
        languageLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(languageLabel)
        
        let runTimeLabel = UILabel()
        runTimeLabel.text = "Duration: \(selectedMovie?.runtime ?? "-")"
        runTimeLabel.numberOfLines = 1
        runTimeLabel.textAlignment = .center
        runTimeLabel.font = UIFont(name: "Copperplate", size: 20)
        runTimeLabel.layer.cornerRadius = 10
        runTimeLabel.layer.borderColor = UIColor.red.cgColor
        runTimeLabel.layer.borderWidth = 1.0 // Толщина рамки
        runTimeLabel.textColor = .white
        runTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        runTimeLabel.sizeToFit()
        containerView.addSubview(runTimeLabel)
        
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
            
            
            favoriteButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 50),
            favoriteButton.heightAnchor.constraint(equalToConstant: 50),
            
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            ratingLabel.widthAnchor.constraint(equalToConstant: 150),
            yearLabel.widthAnchor.constraint(equalToConstant: 150),
            ratingLabel.heightAnchor.constraint(equalToConstant: 30),
            yearLabel.heightAnchor.constraint(equalToConstant: 30),
            
            plotLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            plotLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            plotLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            genreLabel.topAnchor.constraint(equalTo: plotLabel.bottomAnchor, constant: 20),
            genreLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            genreLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            genreLabel.heightAnchor.constraint(equalToConstant: 30),
            
            directorLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 20),
            directorLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            directorLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            directorLabel.heightAnchor.constraint(equalToConstant: 30),
            
            actorsLabel.topAnchor.constraint(equalTo: directorLabel.bottomAnchor, constant: 20),
            actorsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            actorsLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            languageLabel.topAnchor.constraint(equalTo: actorsLabel.bottomAnchor, constant: 20),
            languageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            languageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            languageLabel.heightAnchor.constraint(equalToConstant: 50),
            
            runTimeLabel.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: 20),
            runTimeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            runTimeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            runTimeLabel.heightAnchor.constraint(equalToConstant: 30),
            runTimeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
        
        ])
    }
    
    @objc func pressed() {
        favoriteButton.isSelected.toggle()
        
        guard let selectedMovie = selectedMovie else { return }
        let movieId = selectedMovie.imdbID
        
        let movieIndex = arrayMoviesIdDB.firstIndex { $0.id == movieId }
        
        if let index = movieIndex {
            arrayMoviesIdDB.remove(at: index)
            realmManager.removeMovieId(id: selectedMovie)
            print("Фильм успешно удален из избранного!")
        } else {
            arrayMoviesIdDB.append(MoviesIdDataBase(nameId: movieId))
            realmManager.addMovieId(id: selectedMovie)
            print("Фильм успешно добавлен в избранное!")
        }
    }

    func stateFavoriteStar() {
        guard let selectedMovie = selectedMovie else { return }
        let movieId = selectedMovie.imdbID
        
        let movieIndex = arrayMoviesIdDB.firstIndex { $0.id == movieId }
        favoriteButton.isSelected = (movieIndex != nil)
    }
}
