//
//  MovieCell.swift
//  MCatalog
//
//  Created by Eugene on 3/14/19.
//  Copyright © 2019 Eugene. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    static let reuseIdentifier = "MovieCell"

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionText: UITextView!

}
