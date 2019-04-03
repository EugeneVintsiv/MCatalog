//
//  MovieDetailsViewController.swift
//  MCatalog
//
//  Created by Eugene on 3/15/19.
//  Copyright © 2019 Eugene. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import Moya

class MovieDetailsViewController: UIViewController {

    let provider = MoyaProvider<MovieDBApi>()

    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var runTimeText: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var movieView: UIView!

    var movie: MovieModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        movie.map { fillFields(movie: $0) }
    }

    private func fillFields(movie: MovieModel) {
//        fields
        titleLabel.text = movie.title
        descriptionText.text = movie.overview
        runTimeText.text = "Release date: " + movie.releaseDate
        movieImage.kf.setImage(with: movie.posterUrl())
        getVideo(id: movie.id)

//        scrollView settings
        scrollView.layer.cornerRadius = 11
        scrollView.layer.masksToBounds = true
    }

    private func getVideo(id: Int) {
        print(id)
        provider.request(.video(id: id)) { result in
            switch result {
            case let .success(response):
                do {
                    let res: VideoModel = try response.map(VideoModel.self) //parsing
                    let filtered = res.results.filter({ (videoData: VideoResult) in
                        return videoData.site == "YouTube" && videoData.type == "Trailer"
                    }).prefix(1)
                } catch let err {
                    print(err)
                }
            case let .failure(error):
                print(error)
            }
        }

    }
}
