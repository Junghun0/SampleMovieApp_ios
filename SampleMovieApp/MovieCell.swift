//
//  MovieCell.swift
//  SampleMovieApp
//
//  Created by 박정훈 on 30/01/2019.
//  Copyright © 2019 swift. All rights reserved.
//

import Foundation
import UIKit

class MovieCell :UITableViewCell{
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var opendate: UILabel!
}
