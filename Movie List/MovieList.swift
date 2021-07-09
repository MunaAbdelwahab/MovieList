//
//  MovieList.swift
//  Movie List
//
//  Created by Muna Abdelwahab on 3/17/21.
//

import Foundation

class MovieList: Codable {
    
    let title: String
    let image: String
    let rating: Float
    let realeseYear: Int
    let genre: [String]
    
    init(title: String,image: String,rating: Float,releaseYear: Int,genre: [String]) {
        self.title = title
        self.image = image
        self.rating = rating
        self.realeseYear = releaseYear
        self.genre = genre
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case image = "image"
        case rating = "rating"
        case genre = "genre"
        case realeseYear = "releaseYear"
    }
}
