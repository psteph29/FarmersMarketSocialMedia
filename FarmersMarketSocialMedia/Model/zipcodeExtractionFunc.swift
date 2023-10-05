//
//  zipcodeExtractionFunc.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 10/5/23.
//

import Foundation

func extractZipCode(from address: String) -> Int? {
    let pattern = "\\b(\\d{5}(?:-\\d{4})?)\\b"
    let regex = try? NSRegularExpression(pattern: pattern)
    if let match = regex?.firstMatch(in: address, range: NSRange(address.startIndex..., in: address)) {
        let zipRange = Range(match.range(at: 1), in: address)!
        let zipString = String(address[zipRange])
        let fiveDigitZip = zipString.split(separator: "-")[0]
        return Int(fiveDigitZip)
    }
    return nil
}
