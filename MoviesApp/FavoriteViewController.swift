//
//  FavoriteViewController.swift
//  
//
//  Created by Dubrouski Nikita on 23.08.23.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    var myCollectionView: UICollectionView?
    //var presenterOne: SearchViewPresentor?
    
    var selectedMovie: InfoAboutSelectMovieModel?
    var searchModel: [SearchModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.addSubview(noResultsLabel)
        noResultsLabel.isHidden = false
        
        let mosaicLayout = MosaicLayout2()
        presenterOne
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
            
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
    

