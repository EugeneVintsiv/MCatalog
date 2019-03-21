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

//        movieImage.setImageFromLink(link: (movie?.getBackgroundUrl())!)
        setImage()

        movieImage.contentMode = UIView.ContentMode.scaleAspectFill
        titleLabel.text = movie?.title
        descriptionText.text = movie?.overview

        var frame = descriptionText.frame
        frame.size.height = descriptionText.contentSize.height
        descriptionText.frame = frame
        runTimeText.text = movie?.releaseDate
    }

    private func setImage() {
        guard let url = URL(string: (movie?.getBackgroundUrl())!) else { return }
        let resource = ImageResource(downloadURL: url, cacheKey: "\(movie?.backdropPath ?? "nil")")
        let opts: KingfisherOptionsInfo = [
            .memoryCacheExpiration(.seconds(300))
        ]
        movieImage.kf.setImage(with: resource, options: opts)
    }
}
