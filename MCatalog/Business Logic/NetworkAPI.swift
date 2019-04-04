//
//  NetworkAPI.swift
//  MCatalog
//
//  Created by Eugene on 4/4/19.
//  Copyright © 2019 Eugene. All rights reserved.
//

import Foundation
import Moya

protocol API {
    func nowPlaying(page: Int, completion: @escaping ([MovieModel]) -> Void)
    func search(searchText: String, page: Int, completion: @escaping ([MovieModel]) -> Void)
    func videoLink(id: Int, completion: @escaping (String?) -> Void)
}

class NetworkAPI: API {

    static let shared = NetworkAPI()
    private init() {}

    let movieDbApiProvider = MoyaProvider<MovieDBApi>()

    func nowPlaying(page: Int, completion: @escaping ([MovieModel]) -> Void) {
        movieDbApiProvider.request(.nowPlaying(page: page)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let res: MovieResponse = try response.map(MovieResponse.self) //# parsing
                    completion(res.results)
                } catch {
                    print("error parsing: \(error)")
                    completion([])
                }
            case .failure:
                debugPrint("Error during request")
            }
        }
    }

    func search(searchText: String, page: Int = 1, completion: @escaping ([MovieModel]) -> Void) {
        movieDbApiProvider.request(.search(searchStr: searchText, page: page)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let res: MovieResponse = try response.map(MovieResponse.self) //# parsing
                    completion(res.results)
                } catch {
                    print("error parsing \(error)")
                    completion([])
                }
            case .failure:
                debugPrint("Error during request")
            }
        }
    }

    func videoLink(id: Int, completion: @escaping (String?) -> Void) {
        movieDbApiProvider.request(.video(id: id)) { result in
            switch result {
            case let .success(response):
                do {
                    let res: VideoModel = try response.map(VideoModel.self) //parsing
                    let filtered = self.getFilteredVideoDetails(res: res)

                    if filtered.isEmpty { return }
                    let youtubeLink = "https://www.youtube.com/watch?v="
                    guard let videoURL = URL(string: youtubeLink + filtered[0].key) else { return }

                    Youtube.h264videosWithYoutubeURL(videoURL) { videoInfo, _ in
                        if let videoURLString = videoInfo?["url"] as? String {
                            completion(videoURLString)
                            return
                        }
                        let youtubePlaceholderVideo = "https://www.youtube.com/watch?v=NpEaa2P7qZI"
                        guard let placeHolderUrl = URL(string: youtubePlaceholderVideo) else { return }
                        Youtube.h264videosWithYoutubeURL(placeHolderUrl) { videoInfo, _ in
                            if let placeHolderVideoUrl = videoInfo?["url"] as? String {
                                completion(placeHolderVideoUrl)
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

}

// MARK: - private func
extension NetworkAPI {

    private func getFilteredVideoDetails(res: VideoModel) -> [VideoResult] {
        return res.results.filter({ (videoData: VideoResult) in
            return videoData.site == "YouTube" && videoData.type == "Trailer"
        })
    }
}
