//
//  CoreLocationManager.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 10/11/23.
//

import Foundation
import CoreLocation

protocol CoreLocationManagerDelegate: AnyObject {
    func didUpdateZipCode(_ zipCode: String)
    func didFailWithError(_ error: Error)
}

class CoreLocationManager: NSObject, CLLocationManagerDelegate {
    
    private var locationManager = CLLocationManager()
    weak var delegate: CoreLocationManagerDelegate?
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        // Using CLGeocoder to reverse geocode the location to get the ZIP code
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if let error = error {
                self?.delegate?.didFailWithError(error)
                return
            }

            if let placemark = placemarks?.first, let postalCode = placemark.postalCode {
                self?.delegate?.didUpdateZipCode(postalCode)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithError(error)
    }
}
