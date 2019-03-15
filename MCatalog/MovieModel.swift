//
//  Movie.swift
//  MCatalog
//
//  Created by Eugene on 3/14/19.
//  Copyright © 2019 Eugene. All rights reserved.
//

import UIKit

class MovieModel: NSObject {

    var url: String?
    var title: String = ""
    var overview: String = ""
    var releaseDate: String = ""

    private var dateFormatter = DateFormatter()

    init(url: String?, title: String, overview: String, releaseDate: String) {
        if let path = url {
            self.url = "https://image.tmdb.org/t/p/w500\(path)"
        }
        self.title = title
        self.overview = overview

        dateFormatter.dateFormat = "YYYY-MM-dd"
        self.releaseDate = releaseDate
    }

    static func tmp() -> [MovieModel] {
        return [
            MovieModel(url: "/adw6Lq9FiC9zjYEpOqfq03ituwp.jpg",
                    title: "Fight Club",
                    overview: "A ticking-time-bomb insomniac and a slippery soap " +
                            "salesman channel primal male aggression into a" +
                            "shocking new form of therapy. Their concept catches on, with underg" +
                            "round \"fight clubs\" forming in every town, until" +
                            " an eccentric gets in the way and ignites an out-of-control spiral " +
                            "toward oblivion.A ticking-time-bomb insomniac and a " +
                            "slippery soap salesman channel primal male aggression into a shocki" +
                            "ng new form of therapy. Their concept catches on, with " +
                            "underground \"fight clubs\" forming in every town, until an eccentr" +
                            "ic gets in the way and ignites an out-of-control spiral " +
                            "toward oblivion.A ticking-time-bomb insomniac and a slippery soap s" +
                            "alesman channel primal male aggression into a shocking new " +
                            "form of therapy. Their concept catches on, with underground \"fight" +
                            " clubs\" forming in every town, until an eccentric gets in the " +
                            "way and ignites an out-of-control spiral toward oblivion.",
                    releaseDate: "1999-10-15"),
            MovieModel(url: "/adw6Lq9FiC9zjYEpOqfq03ituwp.jpg",
                    title: "Fight Club",
                    overview: "A ticking-time-bomb insomniac and a slippery soap " +
                            "salesman channel primal male aggression into a" +
                            "shocking new form of therapy. Their concept catches on, with underg" +
                            "round \"fight clubs\" forming in every town, until" +
                            " an eccentric gets in the way and ignites an out-of-control spiral " +
                            "toward oblivion.A ticking-time-bomb insomniac and a " +
                            "slippery soap salesman channel primal male aggression into a shocki" +
                            "ng new form of therapy. Their concept catches on, with " +
                            "underground \"fight clubs\" forming in every town, until an eccentr" +
                            "ic gets in the way and ignites an out-of-control spiral " +
                            "toward oblivion.A ticking-time-bomb insomniac and a slippery soap s" +
                            "alesman channel primal male aggression into a shocking new " +
                            "form of therapy. Their concept catches on, with underground \"fight" +
                            " clubs\" forming in every town, until an eccentric gets in the " +
                            "way and ignites an out-of-control spiral toward oblivion.",
                    releaseDate: "1999-10-15")
        ]
    }

    //    func formattedDate() -> String {
    //        dateFormatter.dateFormat = "MMM dd, yyy"
    //        return releaseDate != nil ? dateFormatter.stringFromDate(releaseDate!) : "Unknown"
    //}
}
