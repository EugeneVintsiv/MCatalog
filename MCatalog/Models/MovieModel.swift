//
//  Movie.swift
//  MCatalog
//
//  Created by Eugene on 3/14/19.
//  Copyright © 2019 Eugene. All rights reserved.
//

import UIKit

import Foundation

public struct MovieResponse: Codable {
    public let page: Int
    public let totalResults: Int
    public let totalPages: Int
    public let results: [MovieModel]

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results = "results"
    }

    public init(page: Int, totalResults: Int, totalPages: Int, results: [MovieModel]) {
        self.page = page
        self.totalResults = totalResults
        self.totalPages = totalPages
        self.results = results
    }
}

public struct MovieModel: Codable {
    public let id: Int
    public let title: String
    public let posterPath: String?
    public let originalTitle: String
    public let backdropPath: String?
    public let overview: String
    public let releaseDate: String

    private let baseImageDomainPath = "https://image.tmdb.org/t/p/w500"

    public func getPosterLink() -> String {
        if posterPath != nil {
            return "\(baseImageDomainPath)\(posterPath!)"
        }
        if backdropPath != nil {
            return "\(baseImageDomainPath)\(backdropPath!)"
        }
        return "https://imgplaceholder.com/420x320?text=No+image"
    }

    public func getBackgroundLink() -> String {
        if backdropPath != nil {
            return "\(baseImageDomainPath)\(backdropPath!)"
        } else {
            return getPosterLink()
        }
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case posterPath = "poster_path"
        case originalTitle = "original_title"
        case backdropPath = "backdrop_path"
        case overview = "overview"
        case releaseDate = "release_date"
    }

    public init(id: Int, title: String, posterPath: String?, originalTitle: String, backdropPath: String?, overview: String, releaseDate: String) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.originalTitle = originalTitle
        self.backdropPath = backdropPath
        self.overview = overview
        self.releaseDate = releaseDate
    }
}
