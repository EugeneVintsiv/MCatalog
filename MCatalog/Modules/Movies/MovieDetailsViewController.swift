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
        movie.map { fillFields(movie: $0) }
    }

    private func fillFields(movie: MovieModel) {
        titleLabel.text = movie.title
        descriptionText.text = movie.overview
        runTimeText.text = "Release date: " + movie.releaseDate
        movieImage.kf.setImage(with: movie.posterUrl())
    }

}
