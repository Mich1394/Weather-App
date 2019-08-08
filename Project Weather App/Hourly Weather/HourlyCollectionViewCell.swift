//
//  HourlyCollectionViewCell.swift
//  Project Weather App
//
//  Created by Deyson Bencosme Abreu on 8/6/19.
//  Copyright © 2019 Deyson Bencosme Abreu. All rights reserved.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
