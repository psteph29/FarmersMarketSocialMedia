//
//  DateConversion.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 10/14/23.
//

import Foundation

struct DateConverter {
    static func userFriendlyDate(from dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"

        if let date = dateFormatter.date(from: dateString) {
            let friendlyDateFormatter = DateFormatter()
            friendlyDateFormatter.dateFormat = "MMMM d, yyyy h:mm a"
            return friendlyDateFormatter.string(from: date)
        } else {
            return nil
        }
    }
}
