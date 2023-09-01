//
//  FavoriteViewController.swift
//  MoviesApp
//
//  Created by Dubrouski Nikita on 23.08.23.
//

import UIKit
import RealmSwift

final class FavoriteViewController: UIViewController {
    
    var notificationToken: NotificationToken?
    
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.identifer)
        return collectionView
    }()
    
    private var layout: MosaicLayout2 = {
        let mosaicLayout = MosaicLayout2()
        return mosaicLayout
    }()
    
    var selectedMovie: [InfoAboutSelectMovieModel] = []
    let realmManager: RealmManagerProtocol = RealmManager()
    lazy var presenterOne: FavoriteViewPresentor = FavoriteViewPresentor(view: self, alomafireProvider: AlomafireProvider())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.frame = self.view.frame
        
        notificationToken = realmManager.realm.observe { [unowned self] note, realm in
            self.presenterOne.getMoviesTaskk()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenterOne.getMoviesTaskk()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}

extension FavoriteViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenterOne.infoMoviesModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.identifer, for: indexPath) as? FavoriteCell else {
            return UICollectionViewCell()
        }
        
        print(indexPath.item)
        let searchInfo = presenterOne.infoMoviesModel[indexPath.item]
        cell.configure(model: searchInfo)
        
        return cell
    }
}

extension FavoriteViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedMovie = presenterOne.infoMoviesModel[indexPath.item]
        
        presenterOne.getInfoForSelectMovie(id: selectedMovie.imdbID)
        DispatchQueue.main.async {
            let infoAboutMoviesViewController = InfoAboutMoviesViewController()
            infoAboutMoviesViewController.selectedMovie = selectedMovie
            self.present(infoAboutMoviesViewController, animated: true, completion: nil)
        }
    }
}
