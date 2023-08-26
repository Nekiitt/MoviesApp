//
//  FavoriteViewController.swift
//  MoviesApp
//
//  Created by Dubrouski Nikita on 23.08.23.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    var myCollectionView: UICollectionView?
    
    var presenterOne: FavoriteViewPresentor?

    var selectedMovie: [InfoAboutSelectMovieModel] = []
    var numberOfMoviesReceived = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let mosaicLayout = MosaicLayout2()
        
        presenterOne = FavoriteViewPresentor(view: self, alomafireProvider: AlomafireProvider())
//        presenterOne?.getMoviesTask()
            
    
        myCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: mosaicLayout)
        myCollectionView?.backgroundColor = UIColor.clear
    
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
        
        myCollectionView?.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.identifer)
        
        view.addSubview(myCollectionView ?? UICollectionView())
      
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
        
        presenterOne?.getMoviesTask()
        myCollectionView?.reloadData()
       
        
      }
}

extension FavoriteViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenterOne?.infoMoviesModel.count ?? 0   }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.identifer, for: indexPath) as? FavoriteCell else {
                return UICollectionViewCell()
            }
            
        guard let searchInfo = presenterOne?.infoMoviesModel[indexPath.item] else { return cell }
        cell.configure(model: searchInfo)
        
        return cell

        }
}

extension FavoriteViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedMovie = presenterOne?.infoMoviesModel[indexPath.item]
        
        presenterOne?.getInfoForSelectMovie(id: selectedMovie?.imdbID ?? "")
        DispatchQueue.main.async {
            let infoAboutMoviesViewController = InfoAboutMoviesViewController()
            infoAboutMoviesViewController.selectedMovie = selectedMovie
            self.present(infoAboutMoviesViewController, animated: true, completion: nil)
        }
    }
}
    


        
    


