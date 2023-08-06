//
//  AlomafireProvider.swift
//  MoviesApp
//
//  Created by Dubrouski Nikita on 24.07.23.
//

import Foundation
import Alamofire

protocol AlomafireProviderProtocol {
    
    func getMovies(nameMovies: String, page: Int) async throws -> MoviesModel
    
    func getInfoForSelectMovie(IdFilm: String) async throws -> InfoAboutSelectMovieModel

}

class AlomafireProvider: AlomafireProviderProtocol {
    
    private let apiMoviesKey = Bundle.main.object(forInfoDictionaryKey: "ApiMoviesKey") as? String ?? "ApiError"
    
    func getMovies(nameMovies: String, page: Int) async throws -> MoviesModel {
        
        let parameters = addParams(queryItems: ["s": nameMovies, "page": String(page)])
        
        return try await AF.request(Constants.basicURL, method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default).serializingDecodable(MoviesModel.self).value
        
    }
    
    func getInfoForSelectMovie(IdFilm: String) async throws -> InfoAboutSelectMovieModel {
        
        let parameters = addParams(queryItems: ["i": IdFilm])
        
        return try await AF.request(Constants.basicURL, method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default).serializingDecodable(InfoAboutSelectMovieModel.self).value
        
    }
        
    private func addParams(queryItems: [String: String]) -> [String: String] {
        var params: [String: String] = [:]
        params = queryItems
        params["apikey"] = apiMoviesKey
        return params
    }
    
}
