import Foundation

protocol MovieListView: AnyObject {
    func showMovies(_ movies: [SearchModel], startIndex: Int)
    func showError(_ error: Error)
}


protocol MovieListPresenter {
    func viewDidLoad()
    func loadMoreMovies()
    func getInfoForSelectedMovie(at index: Int)
    
}

protocol MovieListInteractor {
    func getMovies(nameMovies: String, page: Int, completion: @escaping (Result<[SearchModel], Error>) -> Void)
    func getInfoForSelectedMovie(idFilm: String, completion: @escaping (Result<InfoAboutSelectMovieModel, Error>) -> Void)
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
    
    func getInfoForSelectedMovie(at index: Int) {
        guard index < searchModel.count else { return }
        let searchInfo = searchModel[index]
        interactor.getInfoForSelectedMovie(idFilm: searchInfo.imdbID) { result in
            switch result {
            case .success(let movieModel):
                // Handle the movie model data
                print(movieModel)
            case .failure(let error):
                // Handle the error
                print(error)
            }
        }
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
    
    func getInfoForSelectedMovie(idFilm: String, completion: @escaping (Result<InfoAboutSelectMovieModel, Error>) -> Void) {
        Task {
            do {
                let movieModel = try await alomafireProvider.getInfoForSelectMovie(IdFilm: idFilm)
                completion(.success(movieModel))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
