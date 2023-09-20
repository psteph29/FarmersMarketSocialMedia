//
//  MileToKilometer.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 9/20/23.
//

import Foundation

func milesToKilometers(miles: Double) -> Double {
    let milesMeasurement = Measurement(value: miles, unit: UnitLength.miles)
    let kilometersMeasurement = milesMeasurement.converted(to: .kilometers)
    return kilometersMeasurement.value
}
