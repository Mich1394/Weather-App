//
//  CurrentCell.swift
//  Project Weather App
//
//  Created by Deyson Bencosme Abreu on 8/1/19.
//  Copyright © 2019 Deyson Bencosme Abreu. All rights reserved.
//

import UIKit

class CurrentTableCell: UITableViewCell {

    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var uvIndexLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
