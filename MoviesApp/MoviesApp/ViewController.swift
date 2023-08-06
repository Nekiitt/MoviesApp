//
//  ViewController.swift
//  MoviesApp
//
//  Created by Dubrouski Nikita on 21.07.23.
//

import UIKit


class ViewController: UIViewController, MovieListView {
    
    var myCollectionView: UICollectionView?
    
    var presenter: MovieListPresenter?
    
    var searchModel: [SearchModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIView()
        view.backgroundColor = .black
        
        let mosaicLayout = MosaicLayout()
        
        myCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: mosaicLayout)
        myCollectionView?.backgroundColor = UIColor.clear
    
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
        
        myCollectionView?.register(MosaicCell.self, forCellWithReuseIdentifier: MosaicCell.identifer)
        
        view.addSubview(myCollectionView ?? UICollectionView())
        self.view = view
        
        presenter = MovieListPresenterImpl(view: self, interactor: MovieListInteractorImpl(alomafireProvider: AlomafireProvider()))
        presenter?.viewDidLoad()
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

extension ViewController: UICollectionViewDataSource {
    
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

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == searchModel.count - 1 {
            presenter?.loadMoreMovies()
            
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        presenter?.getInfoForSelectedMovie(at: indexPath.item)
        let selectedMovie = searchModel[indexPath.item]
        let infoAboutMoviesViewController = InfoAboutMoviesViewController()
          
          present(infoAboutMoviesViewController, animated: true, completion: nil)
    }
}


