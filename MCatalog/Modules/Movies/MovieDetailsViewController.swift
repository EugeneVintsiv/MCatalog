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
import BMPlayer

class MovieDetailsViewController: UIViewController {

    let provider = MoyaProvider<MovieDBApi>()

    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var runTimeText: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var movieView: UIView!

    var movie: MovieModel?
    private var player: BMPlayer!

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

        setupPlayer()

        getVideo(id: movie.id) { url in
            guard let url = url else { fatalError("Could not get video url") }
            guard let video = URL(string: url), let cover = movie.backgroundUrl() else {return}
            self.addVideo(videoURL: video, coverURL: cover, title: movie.title)
            self.movieView.isHidden = false
        }

//        scrollView settings
        scrollView.layer.cornerRadius = 11
        scrollView.layer.masksToBounds = true
    }

    func setupPlayer() {
        // Setup video player configurations
        BMPlayerConf.shouldAutoPlay = false
        BMPlayerConf.topBarShowInCase = .always

        player = BMPlayer(customControlView: BMPlayerCustomControlView())
        player.backBlock = { _ in
            self.navigationController?.popViewController(animated: true)
        }

        self.movieView.addSubview(self.player)
        self.player.snp.makeConstraints { make in
            make.top.equalTo(self.movieView)
            make.left.right.equalTo(self.movieView)
            make.height.equalTo(self.movieView.frame.height)
        }
    }

    func addVideo(videoURL: URL, coverURL: URL, title: String) {
        let video = BMPlayerResource(url: videoURL, name: title, cover: coverURL)
        player.setVideo(resource: video)
    }

    private func getVideo(id: Int, completion: @escaping (String?) -> Void) {
        provider.request(.video(id: id)) { result in
            switch result {
            case let .success(response):
                do {
                    let res: VideoModel = try response.map(VideoModel.self) //parsing
                    let filtered = self.getFilteredVideoDetails(res: res)

                    let youtubeLink = "https://www.youtube.com/watch?v="
                    guard let videoURL = URL(string: youtubeLink + filtered[0].key) else { return }

                    Youtube.h264videosWithYoutubeURL(videoURL) { videoInfo, _ in
                        if let videoURLString = videoInfo?["url"] as? String {
                            completion(videoURLString)
                        } else {
                            let youtubePlaceholderVideo = "https://www.youtube.com/watch?v=NpEaa2P7qZI"
                            guard let placeHolderUrl = URL(string: youtubePlaceholderVideo) else { return }
                            Youtube.h264videosWithYoutubeURL(placeHolderUrl) { videoInfo, _ in
                                if let placeHolderVideoUrl = videoInfo?["url"] as? String {
                                    completion(placeHolderVideoUrl)
                                }
                            }
                        }
                    }
                } catch let err {
                    print(err)
                }
            case let .failure(error):
                print(error)
            }
        }

    }

    private func getFilteredVideoDetails(res: VideoModel) -> [VideoResult] {
        return res.results.filter({ (videoData: VideoResult) in
            return videoData.site == "YouTube" && videoData.type == "Trailer"
        })
    }
}
