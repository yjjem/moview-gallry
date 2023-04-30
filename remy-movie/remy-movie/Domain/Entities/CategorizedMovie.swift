//
//  CategorizedMovie.swift
//  remy-movie
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

struct CategorizedMovie: Hashable {
    
    var category: ListCategory
    
    let posterPath: String?
    let adult: Bool
    let overview: String
    let releaseDate: String
    let genreIds: [Int]
    let id: Int
    let originalTitle: String
    let originalLanguage: String
    let title: String
    let backdropPath: String?
    let popularity: Double
    let voteCount: Int
    let video: Bool
    let voteAverage: Double
}