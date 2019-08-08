//
//  HourlyTableViewCell.swift
//  Project Weather App
//
//  Created by Deyson Bencosme Abreu on 8/2/19.
//  Copyright © 2019 Deyson Bencosme Abreu. All rights reserved.
//

import UIKit

class HourlyTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    var data : [HourlyWeatherDataModel] = [HourlyWeatherDataModel]()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.hourlyCollectionView.delegate = self
        self.hourlyCollectionView.dataSource = self
        self.hourlyCollectionView.register(UINib(nibName: "HourlyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "customHourlyCollectionViewCell")
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customHourlyCollectionViewCell", for: indexPath) as! HourlyCollectionViewCell
        if data.count > 0 {
            cell.timeLabel.text = data[indexPath.row].time
            cell.iconImage.image = data[indexPath.row].icon
            cell.temperatureLabel.text = "\(data[indexPath.row].temperature)°"
        }
        return cell
    }
    
}
