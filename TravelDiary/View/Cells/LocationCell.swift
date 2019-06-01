//
//  LocationCell.swift
//  TravelDiary
//
//  Created by Heeral on 5/30/19.
//  Copyright © 2019 heeral. All rights reserved.
//

import Foundation
import UIKit

internal final class LocationCell: UITableViewCell {
    
    
    @IBOutlet weak var placeNameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
     static let defaultReuseIdentifier = "LocationCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        placeNameLabel.text = nil
        dateLabel.text = nil
    }

}
