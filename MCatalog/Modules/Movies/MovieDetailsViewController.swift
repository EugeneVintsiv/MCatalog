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
import BMPlayer

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var runTimeText: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var movieView: UIView!

    var movie: MovieModel?
    private weak var player: BMPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        movie.map(fillFields(movie:))
    }

    private func fillFields(movie: MovieModel) {
//        fields
        titleLabel.text = movie.title
        descriptionText.text = movie.overview
        runTimeText.text = "Release date: " + movie.releaseDate
        movieImage.kf.setImage(with: movie.posterUrl())

        setupPlayer()
        loadVideo(movie: movie)

//        scrollView settings
        scrollView.layer.cornerRadius = 11
        scrollView.layer.masksToBounds = true
    }

    private func setupPlayer() {
        // Setup video player configurations
        BMPlayerConf.shouldAutoPlay = false
        BMPlayerConf.topBarShowInCase = .always

        player = BMPlayer(customControlView: BMPlayerCustomControlView())
        player.backBlock = { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }

        self.movieView.addSubview(self.player)
        self.player.snp.makeConstraints { make in
            make.top.equalTo(self.movieView)
            make.left.right.equalTo(self.movieView)
            make.height.equalTo(self.movieView.frame.height)
        }
    }

    private func loadVideo(movie: MovieModel) {
        NetworkAPI.shared.videoLink(id: movie.id) { url in
            guard let url = url else { fatalError("Could not get video url") }
            guard let video = URL(string: url), let cover = movie.backgroundUrl() else {return}
            self.movieView.isHidden = false
            self.addVideo(videoURL: video, coverURL: cover, title: movie.title)
        }
    }

    private func addVideo(videoURL: URL, coverURL: URL, title: String) {
        let video = BMPlayerResource(url: videoURL, name: title, cover: coverURL)
        player.setVideo(resource: video)
    }
}
