//
//  FavoritePresenter+Protocol.swift
//  MoviesApp
//
//  Created by Dubrouski Nikita on 23.08.23.
//
import RealmSwift
import Foundation

protocol FavoriteViewControllerProtocol {
    
    var infoMoviesModel: [InfoAboutSelectMovieModel] { get }
    func getInfoForSelectMovie(id: String)
    func getMoviesTask()
}

final class FavoriteViewPresentor: FavoriteViewControllerProtocol {
    
    private weak var view: FavoriteViewController?
    
    let alomafireProvider: AlomafireProviderProtocol
    
    var infoMoviesModel: [InfoAboutSelectMovieModel] = []
    var searchModel: [SearchModel] = []
    
    let realmManager: RealmManagerProtocol = RealmManager()
    
    var arrayMoviesIdDB: [MoviesIdDataBase] {
        Array(realmManager.realm.objects(MoviesIdDataBase.self))
    }
    
    required init(view: FavoriteViewController,alomafireProvider: AlomafireProviderProtocol) {
        
        self.view = view
        self.alomafireProvider = alomafireProvider
    }
    
    func getInfoForSelectMovie(id: String) {
        Task {
            do {
                let movieInfo = try await alomafireProvider.getInfoForSelectMovie(IdFilm: id)
                
            } catch {
                
                print(error.localizedDescription)
            }
        }
    }
    
    func getMoviesTask() {
        infoMoviesModel.removeAll()
        
        // Получаем айди фильмов из базы данных Realm
        let movieIds = arrayMoviesIdDB.map { $0.id }
        print(movieIds)
        print(arrayMoviesIdDB)
        
        // Выполняем поиск каждого фильма по его айди
        Task.detached {
            for movieId in movieIds {
                do {
                    let movie = try await self.alomafireProvider.getInfoForSelectMovie(IdFilm: movieId)
                    self.infoMoviesModel.append(movie)
                } catch {
                    print("Error: \(error)")
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.view?.collectionView.reloadData()
            }
        }
    }
}

