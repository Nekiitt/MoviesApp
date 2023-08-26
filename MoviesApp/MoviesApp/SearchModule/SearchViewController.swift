//
//  SearchViewController.swift
//  MoviesApp
//
//  Created by Dubrouski Nikita on 17.08.23.
//


import UIKit

class SearchViewController: UIViewController {
    
    var myCollectionView: UICollectionView?
    var presenterOne: SearchViewPresentor?
    
    lazy var noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No search results"
        label.textAlignment = .center
        label.textColor = UIColor.red
        label.font = UIFont(name: "Copperplate", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return label
    }()
    
    lazy var searchBarForMovie: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.default
      
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.barTintColor = .black
        searchBar.backgroundColor = .gray
        searchBar.searchTextField.backgroundColor = .gray
        navigationItem.titleView = searchBar
        return searchBar
        
    }()

    var selectedMovie: InfoAboutSelectMovieModel?
    var searchModel: [SearchModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.addSubview(noResultsLabel)
        noResultsLabel.isHidden = false
        
        let mosaicLayout = MosaicLayout2()
        
        presenterOne = SearchViewPresentor(view: self, alomafireProvider: AlomafireProvider(), modelSerchInfo: InfoAboutSelectMovieModel(title: "", year: "", rated: "", released: "", runtime: "", genre: "", director: "", writer: "", actors: "", plot: "", language: "", country: "", awards: "", poster: "", ratings: [], metascore: "", imdbRating: "", imdbVotes: "", imdbID: "", type: "", dvd: "", totalSeasons: "", boxOffice: "", production: "", website: "", response: ""))
        
        myCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: mosaicLayout)
        myCollectionView?.backgroundColor = UIColor.clear
    
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
        
        myCollectionView?.register(MosaicCell.self, forCellWithReuseIdentifier: MosaicCell.identifer)
        
        view.addSubview(myCollectionView ?? UICollectionView())
        view.addSubview(searchBarForMovie)
        
        setupUI()
        
    }
    
    func showMovies(_ movies: [SearchModel], startIndex: Int) {
        DispatchQueue.main.async {
            let indexPaths = (startIndex..<startIndex+movies.count).map { IndexPath(item: $0, section: 0) }
    
            self.searchModel += movies
            self.myCollectionView?.insertItems(at: indexPaths)
        }
    }
    
    func noResults() {
        noResultsLabel.isHidden = true
    }
    func resultDone() {
        noResultsLabel.isHidden = false
    }
    
    
    func showError(_ error: Error) {
        print(error)
    }
    
    func setupUI() {
        searchBarForMovie.translatesAutoresizingMaskIntoConstraints = false
        myCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        if let myCollectionView = myCollectionView {
            NSLayoutConstraint.activate([
                searchBarForMovie.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                searchBarForMovie.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                searchBarForMovie.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                searchBarForMovie.heightAnchor.constraint(equalToConstant: 50),
                
                myCollectionView.topAnchor.constraint(equalTo: searchBarForMovie.bottomAnchor, constant: 8),
                myCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                myCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                myCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
            ])
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MosaicCell.identifer, for: indexPath) as? MosaicCell else {
            return UICollectionViewCell()
        }
        
        let searchInfo = searchModel[indexPath.item]
        cell.configure(model: searchInfo)
        
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == searchModel.count - 1 {
            presenterOne?.loadMoreMovies(name: searchBarForMovie.text ?? "")
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedMovie = searchModel[indexPath.item]
        
        presenterOne?.getInfoForSelectMovie(id: selectedMovie.imdbID) { [weak self] movie in
            self?.selectedMovie = movie
            DispatchQueue.main.async {
                let infoAboutMoviesViewController = InfoAboutMoviesViewController()
                infoAboutMoviesViewController.selectedMovie = movie
                self?.present(infoAboutMoviesViewController, animated: true, completion: nil)
            }
        }
    }
}
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchModel = []
        guard let searchText = searchBar.text else { return }
        
        presenterOne?.getMovies(nameMovies: searchText, page: 1)
        searchBar.resignFirstResponder()
        myCollectionView?.reloadData()
        
    }
    
}


