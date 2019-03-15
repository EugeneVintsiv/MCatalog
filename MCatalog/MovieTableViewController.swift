//
//  MovieTableViewController.swift
//  MCatalog
//
//  Created by Eugene on 3/14/19.
//  Copyright © 2019 Eugene. All rights reserved.
//

import UIKit

class MovieTableViewController: UIViewController {

    @IBOutlet weak var movieTableView: UITableView!
    private var tableView: UITableView!
    private var movies: [MovieModel] = MovieModel.tmp()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        movieTableView.dataSource = self
        movieTableView.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetail" {
            guard let viewController = segue.destination as? MovieDetailsViewController
                else { fatalError("Incorrect destination view contoller")}
            viewController.movie = movies[movieTableView.indexPathForSelectedRow!.row]
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
//        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier) as! MovieCell

        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier) as? MovieCell else {
                fatalError("DequeueReusableCell failed while casting")
        }

        let movie = self.movies[indexPath.row]

        cell.movieImage.dowloadFromServer(link: movie.url!)
        cell.title.text = movie.title
        cell.descriptionText.text = movie.overview
        return cell
    }

}
