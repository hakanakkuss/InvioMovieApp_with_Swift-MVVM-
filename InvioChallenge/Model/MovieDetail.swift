//
//  MovieDetail.swift
//  InvioChallenge
//
//  Created by Macbook Pro on 25.11.2022.
//

import Foundation

struct MovieDetail: Codable {

    var title: String
    var runTime: String
    var year: String
    var language: String
    var ratings: String
    var plot: String
    var director: String
    var writer: String
    var actors: String
    var country: String
    var boxOffice: String
    var poster: String?
    var imdbID: String

    enum CodingKeys: String, CodingKey {

        case title = "Title"
        case runTime = "Runtime"
        case year = "Year"
        case language = "Language"
        case ratings = "imdbRating"
        case plot = "Plot"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case country = "Country"
        case boxOffice = "BoxOffice"
        case poster = "Poster"
        case imdbID = "imdbID"
    }

}
