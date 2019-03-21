//
//  MovieTableViewController.swift
//  MCatalog
//
//  Created by Eugene on 3/14/19.
//  Copyright © 2019 Eugene. All rights reserved.
//

import UIKit
import Moya

class MovieTableViewController: UIViewController {

    @IBOutlet weak var movieTableView: UITableView!
    private var movies: [MovieModel] = []

    private let page = "1"

    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.dataSource = self
        movieTableView.delegate = self
        loadData()

        configureSearch()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetail" {
            guard let viewController = segue.destination as? MovieDetailsViewController
                else { fatalError("Incorrect destination view contoller")}
            viewController.movie = movies[movieTableView.indexPathForSelectedRow!.row]
        }
    }
}

// MARK: - loading content
extension MovieTableViewController {
    func loadData() {
        movieDbApiProvider.request(.nowPlaying(page: self.page)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let res: MovieResponse = try response.map(MovieResponse.self) //# parsing
                    self.movies = res.results
                    self.movieTableView.reloadData()
                } catch {
                    print("error parsing: \(error)")
                }
            case .failure:
                debugPrint("Error during request via MOYA")
            }
        }
    }
}

// MARK: UISearchBarDelegate
extension MovieTableViewController: UISearchBarDelegate {

    private func configureSearch() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search..."
        self.navigationItem.titleView = searchBar
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {

            movieDbApiProvider.request(.search(searchStr: searchText, page: page)) { (result) in
                switch result {
                case .success(let response):
                    do {
                        let res: MovieResponse = try response.map(MovieResponse.self) //# parsing
                        self.movies = res.results
                        self.movieTableView.reloadData()
                    } catch {
                        print("error parsing \(error)")
                    }
                case .failure:
                    debugPrint("Error during request via MOYA")
                    self.loadData()
                }
            }
        } else {
            self.loadData()
        }
    }

}

extension MovieTableViewController: UITableViewDelegate {

}

extension MovieTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier) as? MovieCell else {
            fatalError("DequeueReusableCell failed while casting")
        }

        let movie = self.movies[indexPath.row]

        cell.movieImage.setImageFromLink(link: movie.getPosterUrl())
        cell.title.text = movie.title
        cell.descriptionText.text = movie.overview
        return cell
    }

}
