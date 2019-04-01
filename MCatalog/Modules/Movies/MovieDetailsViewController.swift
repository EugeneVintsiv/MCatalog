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

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var runTimeText: UITextView!

    var movie: MovieModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        movie
            .map {
                titleLabel.text = $0.title
                descriptionText.text = $0.overview
                runTimeText.text = $0.releaseDate

                setImage(movie: $0)
            }
    }

    private func setImage(movie: MovieModel) {
        URL(string: movie.getPosterLink())
                .map {
                    movieImage.kf.setImage(with: $0)
                    movieImage.contentMode = UIView.ContentMode.scaleAspectFill
                }
    }

}
