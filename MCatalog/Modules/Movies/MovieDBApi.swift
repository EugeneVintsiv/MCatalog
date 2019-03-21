//
//  MovieDBApi.swift
//  MCatalog
//
//  Created by Eugene on 3/20/19.
//  Copyright © 2019 Eugene. All rights reserved.
//

import Foundation
import Moya

let movieDbApiProvider = MoyaProvider<MovieDBApi>()

enum MovieDBApi {
    case nowPlaying(page: String)
    case search(searchStr: String, page: String)

    private var apiKey: String {
        return "7a312711d0d45c9da658b9206f3851dd"
    }
}

extension MovieDBApi: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org")!
    }

    var path: String {
        switch self {
        case .nowPlaying:
            return "3/movie/now_playing"
        case .search:
            return "3/search/movie"
        }

    }
    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        switch self {
        case .nowPlaying:
            return NSDataAsset(name: "sampleMoviesPageJson")!.data
        case .search:
            return NSDataAsset(name: "sampleMoviesPageJson")!.data
        }

    }

    var task: Task {
        switch self {
        case .nowPlaying(let page):
            let params = ["api_key": apiKey, "page": page]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .search(let searchStr, let page):
            let params = ["api_key": apiKey, "page": page, "query": searchStr]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }

    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

}
