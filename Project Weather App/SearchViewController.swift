//
//  SearchViewController.swift
//  Project Weather App
//
//  Created by Deyson Bencosme Abreu on 8/7/19.
//  Copyright © 2019 Deyson Bencosme Abreu. All rights reserved.
//

import UIKit
import MapKit

protocol ChangeLocationDelegate {
    func location(latitude: String, longitude: String)
}

class SearchViewController: UIViewController, MKLocalSearchCompleterDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var delegate : ChangeLocationDelegate?

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTableView: UITableView!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompleter.delegate = self
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty  == false {
            searchCompleter.queryFragment = searchText
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        resultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.backgroundColor = .clear
        cell.textLabel?.text = searchResults[indexPath.row].title
        cell.detailTextLabel?.text = searchResults[indexPath.row].subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let completion = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            let lat = String(coordinate!.latitude)
            let lon = String(coordinate!.longitude)
            self.delegate?.location(latitude: lat, longitude: lon)
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    


}
