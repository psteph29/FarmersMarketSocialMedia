//
//  SearchCollectionExtension.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 10/14/23.
//

import Foundation
import UIKit



extension SearchCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadBusinessListings()
    }
}

// This extension allows the SearchCollectionViewController to conform to the CoreLocationManagerDelegate protocol.
// This means it can handle location updates and errors from the CoreLocationManager.
extension SearchCollectionViewController: CoreLocationManagerDelegate {
    
    // This method is called when the CoreLocationManager successfully gets a ZIP code.
    func didUpdateZipCode(_ zipCode: String) {
        // Run UI-related updates on the main thread to ensure smooth UI performance.
        DispatchQueue.main.async {
            // Set the found ZIP code to the search bar's text.
            self.zipCodeSearchBar.text = zipCode
            
            // Load business listings based on the updated ZIP code.
            self.loadBusinessListings()
        }
    }
    
    // Displays an alert when location services are disabled or there's an error in accessing them.
    func showLocationServicesAlert() {
        let alert = UIAlertController(title: "Location Services Disabled",
                                      message: "Please enable Location Services in Settings or manually input your ZIP code.",
                                      preferredStyle: .alert)
        
        // Action for when the user clicks "OK", dismissing the alert.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Action for when the user clicks "Settings", which will take them to the app's settings in the Settings app.
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }))
        
        // Present the alert to the user.
        present(alert, animated: true, completion: nil)
    }
    
    // This method is called when the CoreLocationManager encounters an error.
    func didFailWithError(_ error: Error) {
        // Show the location services alert to inform the user.
        showLocationServicesAlert()
    }
}
