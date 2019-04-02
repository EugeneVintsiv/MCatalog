//
//  MovieTableViewController.swift
//  MCatalog
//
//  Created by Eugene on 3/14/19.
//  Copyright © 2019 Eugene. All rights reserved.
//

import UIKit
import Moya
import Kingfisher

class MovieTableViewController: UIViewController {

    let movieDbApiProvider = MoyaProvider<MovieDBApi>()

    @IBOutlet weak var movieTableView: UITableView!
    private var movies: [MovieModel] = []
    private var page = 1
    private let searchBar = UISearchBar()
    private static let minLengthForSearch = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.dataSource = self
        movieTableView.delegate = self
        movieTableView.prefetchDataSource = self
        configureRefresh()
        configureSearch()

        loadDataWithReset()
    }

}

// MARK: - search bar config
extension MovieTableViewController {
    private func configureRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl.addTarget(self, action: Selector(("refresh")), for: .valueChanged)
        movieTableView.refreshControl = refreshControl
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let movieRow  = movieTableView.indexPathForSelectedRow?.row else {return}
        (segue.destination as? MovieDetailsViewController)?.movie = self.movies[movieRow]
    }

    @objc func refresh() {
        if self.searchBar.text!.count >= MovieTableViewController.minLengthForSearch {
            self.search(searchText: self.searchBar.text!)
        } else {
            self.loadDataWithReset()
        }

        self.movieTableView.refreshControl?.endRefreshing()
    }

    private func resetParams() {
        self.page = 1
        self.movies = []
    }

    private func loadDataWithReset() {
        resetParams()
        loadData()
    }
}

// MARK: - loading content
extension MovieTableViewController {
    func loadData() {
        movieDbApiProvider.request(.nowPlaying(page: String(self.page))) { (result) in
            switch result {
            case .success(let response):
                do {
                    let res: MovieResponse = try response.map(MovieResponse.self) //# parsing
                    self.movies.append(contentsOf: res.results)
                    self.movieTableView.reloadData()
                    self.page+=1
                } catch {
                    print("error parsing: \(error)")
                    return
                }
            case .failure:
                debugPrint("Error during request")
            }
        }
    }
}

// MARK: UISearchBarDelegate
extension MovieTableViewController: UISearchBarDelegate {

    private func configureSearch() {
        searchBar.delegate = self
        searchBar.placeholder = "Search..."
        self.navigationItem.titleView = searchBar
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadDataWithReset()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            search(searchText: searchText)
        } else {
            loadDataWithReset()
        }
    }

    private func search(searchText: String) {
        if searchText.count < MovieTableViewController.minLengthForSearch { return }

        movieDbApiProvider.request(.search(searchStr: searchText, page: String(1))) { (result) in
            switch result {
            case .success(let response):
                do {
                    let res: MovieResponse = try response.map(MovieResponse.self) //# parsing
                    self.movies = res.results
                    self.movieTableView.reloadData()
                } catch {
                    print("error parsing \(error)")
                    return
                }
            case .failure:
                debugPrint("Error during request")
                self.loadDataWithReset()
            }
        }
    }
}

// MARK: - DataSourcePrefetching
extension MovieTableViewController: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell(for:)) {
            loadData()
        }
    }

    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row == (self.movies.count - 1)
    }

}

// MARK: - UITableViewDelegate
extension MovieTableViewController: UITableViewDelegate {

}

// MARK: - TableViewDataSource
extension MovieTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier) as? MovieCell else {
            fatalError("DequeueReusableCell failed while casting")
        }

        let movie = self.movies[indexPath.row]
        setImage(cell: cell, movie: movie)
        cell.title.text = movie.title
        cell.descriptionText.text = movie.overview
        return cell
    }

    private func setImage(cell: MovieCell, movie: MovieModel) {
        let url = URL(string: movie.getPosterLink())
        cell.movieImage.kf.setImage(with: url)
    }

}
