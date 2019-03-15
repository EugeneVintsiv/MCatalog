//
//  MovieDetailsViewController.swift
//  MCatalog
//
//  Created by Eugene on 3/15/19.
//  Copyright © 2019 Eugene. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var runTimeText: UITextView!

    var movie: MovieModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        //        movieImage.setImageWithURL(NSURL(string:(movie?.url)!)!)
        movieImage.dowloadFromServer(link: (movie?.url!)!)
        movieImage.contentMode = UIView.ContentMode.scaleAspectFill
        titleLabel.text = movie?.title
        descriptionText.text = movie?.overview

        var frame = descriptionText.frame
        frame.size.height = descriptionText.contentSize.height
        descriptionText.frame = frame
        runTimeText.text = movie?.releaseDate
        //        runTimeText.text = movie?.formattedDate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
