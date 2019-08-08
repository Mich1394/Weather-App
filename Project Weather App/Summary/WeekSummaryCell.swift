//
//  WeekSummaryCell.swift
//  Project Weather App
//
//  Created by Deyson Bencosme Abreu on 8/2/19.
//  Copyright © 2019 Deyson Bencosme Abreu. All rights reserved.
//

import UIKit

class WeekSummaryCell: UITableViewCell {

    @IBOutlet weak var summaryLabel: UILabel!
    
    var im = UIImageView(image: UIImage(named: "Asset 5"))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        im.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
