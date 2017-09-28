//
//  ShowFetchedDataTableViewCell.swift
//  Practice
//
//  Created by Muhammad Azher on 27/09/2017.
//  Copyright © 2017 Muhammad Azher. All rights reserved.
//

import UIKit

class ShowFetchedDataTableViewCell: UITableViewCell {
    @IBOutlet weak var fetchedName: UILabel!
    @IBOutlet weak var fetchedLocation: UILabel!
    @IBOutlet weak var totalRating: HCSStarRatingView!
    @IBOutlet weak var totalDistance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
