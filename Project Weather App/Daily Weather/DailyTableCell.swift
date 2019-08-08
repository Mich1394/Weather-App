//
//  DailyCell.swift
//  Project Weather App
//
//  Created by Deyson Bencosme Abreu on 8/1/19.
//  Copyright © 2019 Deyson Bencosme Abreu. All rights reserved.
//

import UIKit

class DailyTableCell: UITableViewCell {

    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var tempHighLabel: UILabel!
    @IBOutlet weak var tempLowLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
