//
//  MovieDetails.swift
//  MoviesApp
//
//  Created by Dubrouski Nikita on 4.08.23.
//

import Foundation

struct MovieDetails {
    let title: String
    let year: String
    let plot: String
    // Add any other properties you need
    
    init(title: String, year: String, plot: String) {
        self.title = title
        self.year = year
        self.plot = plot
    }
}
