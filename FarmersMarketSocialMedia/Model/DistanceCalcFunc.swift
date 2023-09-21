//
//  DistanceCalcFunc.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 9/15/23.
//

import Foundation

// This function calculates the distance between two given latitude and longitude coordinates.
func calculateDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
    // Earth's average radius in kilometers
    let radius = 6371.0

    // Convert difference of latitudes and longitudes from degrees to radians
    let dLat = (lat2 - lat1).degreesToRadians
    let dLon = (lon2 - lon1).degreesToRadians

    // Haversine formula calculation to find distance between two lat-long coordinates
    let a = sin(dLat / 2) * sin(dLat / 2) +
            cos(lat1.degreesToRadians) * cos(lat2.degreesToRadians) *
            sin(dLon / 2) * sin(dLon / 2)
    let c = 2 * atan2(sqrt(a), sqrt(1 - a))

    // Distance in kilometers
    return radius * c
}

// Double extension to provide a method that converts degrees to radians
extension Double {
    var degreesToRadians: Double {
        return self * .pi / 180.0
    }
}

// This function finds and returns ZIP codes within the given travel distance from the user's ZIP code based on JSON data.
func findZipCodesWithinDistance(userZipcode: String, travelDistance: Double, jsonData: Data) -> [String] {
    do {
        // Decode JSON data into an array of Location objects
        let locations = try JSONDecoder().decode([Location].self, from: jsonData)
        
        // Find user's location details based on given ZIP code
        let userLocation = locations.first { $0.ZIPCODE == userZipcode }
        
        // Extract user's latitude and longitude; Return empty array if any value is nil or cannot be converted
        guard let userLatStr = userLocation?.LAT, let userLongStr = userLocation?.LONG else {
            return []
        }
        
        let userLat = Double(userLatStr)!
        let userLong = Double(userLongStr)!
        
        // Filter out locations within the specified travel distance
        let nearbyZipcodes = locations.filter { location in
            if let latStr = location.LAT, let longStr = location.LONG {
                let lat = Double(latStr)!
                let long = Double(longStr)!
                let distance = calculateDistance(lat1: userLat, lon1: userLong, lat2: lat, lon2: long)
                return distance <= travelDistance
            }
            return false
        }
        
        // Map and return ZIP codes of nearby locations
        return nearbyZipcodes.map { $0.ZIPCODE! }
    } catch {
        // Handle JSON decoding error
        print("Error decoding JSON: \(error)")
        return []
    }
}
