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
import DZNEmptyDataSet

class MovieTableViewController: UIViewController {

    let movieDbApiProvider = MoyaProvider<MovieDBApi>()

    @IBOutlet weak var movieTableView: UITableView!
    private var movies: [MovieModel] = []
    private var page = 1
    private let searchBar = UISearchBar()
    private static let minLengthForSearch = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegations()
        configureRefresh()
        configureSearch()

        loadDataWithReset()
    }

    private func setupDelegations() {
        movieTableView.dataSource = self
        movieTableView.delegate = self
        movieTableView.prefetchDataSource = self
        movieTableView.emptyDataSetSource = self
        movieTableView.emptyDataSetDelegate = self
        movieTableView.tableFooterView = UIView()
    }

}

// MARK: - search bar config
extension MovieTableViewController {
    private func configureRefresh() {
        let refreshControl = UIRefreshControl()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...", attributes: attributes)
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
        searchBar.backgroundColor = UIColor(named: "mainBgColor")! //color from assets
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
        fillFields(movie: movie, cell: cell)
//        cell.selectionStyle = UITableViewCell.SelectionStyle.hash("2C3B53");
        let view = UIView()
        view.backgroundColor = UIColor(named: "2C3B53")
        cell.selectedBackgroundView = view
        return cell
    }

    private func fillFields(movie: MovieModel, cell: MovieCell) {
        cell.movieImage.kf.setImage(with: movie.posterUrl())
        cell.title.text = movie.title
        cell.descriptionText.text = movie.overview

        if searchBar.text!.count >= MovieTableViewController.minLengthForSearch {
            cell.title.attributedText = highlight(searchStr: searchBar.text!, text: movie.title)
        }
    }

    private func highlight(searchStr: String, text: String) -> NSAttributedString {
        let attrString: NSMutableAttributedString = NSMutableAttributedString(string: text)

        let range: NSRange = (text as NSString).range(of: searchStr, options: NSString.CompareOptions.caseInsensitive)
        attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
        attrString.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.yellow, range: range)

        return attrString
    }

}

// MARK: - Deal with the empty data set
extension MovieTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    // Add title for empty dataset
    func title(forEmptyDataSet _: UIScrollView!) -> NSAttributedString! {
        let str = "No movies"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    // Add description/subtitle on empty dataset
    func description(forEmptyDataSet _: UIScrollView!) -> NSAttributedString! {
        let str = "There are no movies found."
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }

}
