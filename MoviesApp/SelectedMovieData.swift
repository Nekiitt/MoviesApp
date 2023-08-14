//
//  SelectedMovieData .swift
//  MoviesApp
//
//  Created by Dubrouski Nikita on 8.08.23.
//

import Foundation

struct SelectedMovieData {
    let title: String
    let genre: String
    
    init(title: String, genre: String) {
        self.title = title
        self.genre = genre
    }
}
