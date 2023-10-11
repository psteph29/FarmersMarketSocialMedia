//
//  CoreLocationManager.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 10/11/23.
//

import Foundation
import CoreLocation

// A custom location manager class to handle location requests and inform the delegate about location updates or errors.
class CoreLocationManager: NSObject, CLLocationManagerDelegate {
    
    // A flag to determine if permission was requested. Used to decide when to show the error to the user.
    var didRequestPermission = false
    
    // The system's location manager instance.
    private var locationManager = CLLocationManager()
    
    // A delegate that will be notified about location updates or errors.
    weak var delegate: CoreLocationManagerDelegate?
    
    // Initializer sets up the location manager.
    override init() {
        super.init()
        setupLocationManager()
    }
    
    // Sets the delegate for the location manager and requests authorization for location access when in use.
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    // Function to request the current location.
    func requestLocation() {
        // Check if the location permission status is not determined.
        if CLLocationManager.authorizationStatus() == .notDetermined {
            didRequestPermission = true
        }
        locationManager.requestLocation()
    }

    // Delegate method called when the location manager updates locations.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Get the most recent location.
        guard let location = locations.last else { return }

        // Using CLGeocoder to reverse geocode the location to get the ZIP code.
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            // Handle the error and inform the delegate.
            if let error = error {
                self?.delegate?.didFailWithError(error)
                return
            }

            // If successful, get the postal code (ZIP code) and inform the delegate.
            if let placemark = placemarks?.first, let postalCode = placemark.postalCode {
                self?.delegate?.didUpdateZipCode(postalCode)
            }
        }
    }
    
    // Delegate method called when there's an error with location updates.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // If permission was not just requested, inform the delegate about the error.
        if !didRequestPermission {
            delegate?.didFailWithError(error)
        }
        // Reset the flag after handling.
        didRequestPermission = false
    }
}

// A protocol that defines methods for informing about location updates or errors.
protocol CoreLocationManagerDelegate: AnyObject {
    // Called when a new ZIP code is determined.
    func didUpdateZipCode(_ zipCode: String)
    
    // Called when there's an error with location updates.
    func didFailWithError(_ error: Error)
}
