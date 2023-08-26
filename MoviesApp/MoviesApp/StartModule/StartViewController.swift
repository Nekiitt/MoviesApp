//
//  ViewController.swift
//  MoviesApp
//
//  Created by Dubrouski Nikita on 21.07.23.
//

import UIKit

class StartViewController: UIViewController {
    
    var myCollectionView: UICollectionView?
    
    var presenterOne: StartViewControllerProtocol?
    var selectedMovie: InfoAboutSelectMovieModel?
    var searchModel: [SearchModel] = []
    var didCloseInfoScreen: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIView()
        view.backgroundColor = .black
        
        presenterOne = StartViewControllerPresenter(view: self, alomafireProvider: AlomafireProvider(), modelSerchInfo: InfoAboutSelectMovieModel(title: "", year: "", rated: "", released: "", runtime: "", genre: "", director: "", writer: "", actors: "", plot: "", language: "", country: "", awards: "", poster: "", ratings: [], metascore: "", imdbRating: "", imdbVotes: "", imdbID: "", type: "", dvd: "", totalSeasons: "", boxOffice: "", production: "", website: "", response: ""))
        
        presenterOne?.getMovies(nameMovies: "home", page: 1)
        
        let mosaicLayout = MosaicLayout()
        
        myCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: mosaicLayout)
        myCollectionView?.backgroundColor = UIColor.clear
    
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
        
        myCollectionView?.register(MosaicCell.self, forCellWithReuseIdentifier: MosaicCell.identifer)
        
        view.addSubview(myCollectionView ?? UICollectionView())
        self.view = view
        

    
    }
    
    func showMovies(_ movies: [SearchModel], startIndex: Int) {
        DispatchQueue.main.async {
            let indexPaths = (startIndex..<startIndex+movies.count).map { IndexPath(item: $0, section: 0) }
            self.searchModel += movies
            self.myCollectionView?.insertItems(at: indexPaths)
        }
    }
    
    func showError(_ error: Error) {
        print(error)
    }
    

}

extension StartViewController: UICollectionViewDataSource {
    
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

extension StartViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == searchModel.count - 1 {
            presenterOne?.loadMoreMovies()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedMovie = searchModel[indexPath.item]
        
        presenterOne?.getInfoForSelectMovie(id: selectedMovie.imdbID) { [weak self] movie in
            self?.selectedMovie = movie
            //необходимые действия после получения информации о фильме
            DispatchQueue.main.async {
                let infoAboutMoviesViewController = InfoAboutMoviesViewController()
                infoAboutMoviesViewController.selectedMovie = movie
                self?.present(infoAboutMoviesViewController, animated: true, completion: nil)
            }
        }
    }
    
}
