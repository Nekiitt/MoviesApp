//
//  Protocols.swift
//  MoviesApp
//
//  Created by Dubrouski Nikita on 27.07.23.
//

import Foundation

protocol MovieListView: AnyObject {
    func showMovies(_ movies: [SearchModel], startIndex: Int)
    func showError(_ error: Error)
}


protocol MovieListPresenter {
    func viewDidLoad()
    func loadMoreMovies()
    func didSelectMovie(at index: Int)
}

protocol MovieListInteractor {
    func getMovies(nameMovies: String, page: Int, completion: @escaping (Result<[SearchModel], Error>) -> Void)
}


class MovieListPresenterImpl: MovieListPresenter {
    weak var view: MovieListView?
    let interactor: MovieListInteractor
    
    var searchModel: [SearchModel] = []
    var currentPage = 1
    var isFetchingMovies = false
    
    init(view: MovieListView, interactor: MovieListInteractor) {
        self.view = view
        self.interactor = interactor
    }
    
    func viewDidLoad() {
        loadMovies()
    }
    
    func loadMovies() {
        
        guard !isFetchingMovies else { return }
        isFetchingMovies = true
            
        interactor.getMovies(nameMovies: "home", page: currentPage) { [weak self] result in
            guard let self = self else { return }
                
            switch result {
            case .success(let movies):
                let startIndex = self.searchModel.count // Calculate the startIndex
                self.searchModel += movies
                self.view?.showMovies(movies, startIndex: startIndex) // Pass the startIndex parameter
                self.currentPage += 1
                self.isFetchingMovies = false
            case .failure(let error):
                self.view?.showError(error)
            }
        }
    
    }
    
    func loadMoreMovies() {
        loadMovies()
    }
    
    func didSelectMovie(at index: Int) {
        let selectedMovie = searchModel[index]
        print(selectedMovie.imdbID)
    }
}

class MovieListInteractorImpl: MovieListInteractor {
    let alomafireProvider: AlomafireProviderProtocol
    
    init(alomafireProvider: AlomafireProviderProtocol) {
        self.alomafireProvider = alomafireProvider
    }
    
    func getMovies(nameMovies: String, page: Int, completion: @escaping (Result<[SearchModel], Error>) -> Void) {
        Task {
            do {
                let moviesModel = try await alomafireProvider.getMovies(nameMovies: nameMovies, page: page)
                let newMovies = moviesModel.search.map { SearchModel(data: $0) }
                completion(.success(newMovies))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
