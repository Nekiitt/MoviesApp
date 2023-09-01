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
    func getMoviesTaskk()
    
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
                
                print(movieInfo.imdbID)
            } catch {
                print(error)
                
            }
        }
    }
    
    
    func getMoviesTask() {
        
        if let favoriteMovieIDs = UserDefaults.standard.stringArray(forKey: "FavoriteMovieIDs") {
            let group = DispatchGroup() // Create a dispatch group
            let queue = DispatchQueue(label: "favoriteQueue") // Create a serial dispatch queue
            
            var newMovies: [InfoAboutSelectMovieModel] = [] // Store new movies here
            
            for id in favoriteMovieIDs {
                group.enter() // Enter the dispatch group
                
                Task.detached {
                    do {
                        let movieInfo = try await self.alomafireProvider.getInfoForSelectMovie(IdFilm: id)
                        let movie = movieInfo
                        queue.sync { // Synchronize access to the newMovies array
                            if !self.infoMoviesModel.contains(where: { $0.imdbID == id }) {
                                newMovies.append(movie) // Append new movies
                            }
                        }
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    group.leave() // Leave the dispatch group once the movie information is fetched
                }
            }
            
            group.notify(queue: .main) { [weak self] in // Perform the updates once all movie information is fetched
                guard let self = self else { return }
                self.infoMoviesModel.append(contentsOf: newMovies) // Append new movies to the array
                newMovies.removeAll() // Clear the newMovies array (safely within the same queue)
                
                DispatchQueue.main.async {
                    let indexPaths = (self.infoMoviesModel.count - newMovies.count ..< self.infoMoviesModel.count).map { index in
                        IndexPath(item: index, section: 0)
                    }
                    self.view?.collectionView.insertItems(at: indexPaths) // Insert new movies into the collection view
                }
            }
        }
    }
    
    
    func getMoviesTaskk() {
        infoMoviesModel.removeAll()
        
        // Получаем айди фильмов из базы данных Realm
        let movieIds = arrayMoviesIdDB.map { $0.id }
        print(movieIds)
        print(arrayMoviesIdDB)
        
        // Выполняем поиск каждого фильма по его айди
        Task.detached(priority: .userInitiated) {
            
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

