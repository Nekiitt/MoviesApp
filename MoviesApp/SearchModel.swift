//
//  SearchModel.swift
//  MoviesApp
//
//  Created by Dubrouski Nikita on 24.07.23.
//

import Foundation

struct SearchModel {
    var title: String
    var year: String
    var imdbID: String
    var type: String
    var poster: String
    
    init(data: Search) {
        title = data.title
        year = data.year
        imdbID = data.imdbID
        type = data.type
        poster = data.poster
        
    }
}
