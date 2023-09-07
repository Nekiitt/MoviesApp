
import Foundation

protocol StartViewControllerProtocol {
    func getMovies(nameMovies: String, page: Int)
    func loadMoreMovies()
    func getInfoForSelectMovie(id: String, completion: @escaping (InfoAboutSelectMovieModel?) -> Void)
}

final class StartViewControllerPresenter: StartViewControllerProtocol {
    
    private weak var view: StartViewController?
    let alomafireProvider: AlomafireProviderProtocol
    var infoMoviesModel: InfoAboutSelectMovieModel
    var searchModel: [SearchModel] = []
    var currentPage = 1
    var isFetchingMovies = false
    
    required init(view: StartViewController,alomafireProvider: AlomafireProviderProtocol, modelSerchInfo: InfoAboutSelectMovieModel) {
        self.view = view
        self.alomafireProvider = alomafireProvider
        self.infoMoviesModel = modelSerchInfo
    }
    
    func getMovies(nameMovies: String, page: Int) {
        Task {
            do {
                let moviesModel = try await alomafireProvider.getMovies(nameMovies: nameMovies, page: page)
                let newMovies = moviesModel.search.map { SearchModel(data: $0) }
                self.searchModel = newMovies
                await self.view?.showMovies(newMovies, startIndex: 0)
                
            } catch {
                print(error)
            }
        }
    }
    
    func getInfoForSelectMovie(id: String, completion: @escaping (InfoAboutSelectMovieModel?) -> Void) {
        Task {
            do {
                let movieInfo = try await alomafireProvider.getInfoForSelectMovie(IdFilm: id)
                completion(movieInfo)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func loadMoreMovies() {
        guard !isFetchingMovies else {
            return // Если уже идет загрузка, то ничего не делаем
        }
        
        currentPage += 1 // Увеличиваем номер страницы
        isFetchingMovies = true
        
        Task {
            do {
                let moviesModel = try await alomafireProvider.getMovies(nameMovies: "home", page: currentPage)
                let newMovies = moviesModel.search.map { SearchModel(data: $0) }
                
                DispatchQueue.main.async {
                    self.searchModel += newMovies // Добавляем новые фильмы к существующему массиву
                    self.view?.showMovies(newMovies, startIndex: self.searchModel.count - newMovies.count) // Передаем фильмы для отображения
                }
                
                isFetchingMovies = false
            } catch {
                print(error)
                isFetchingMovies = false
            }
        }
    }
}
