//
//  FarmDataStructure.swift
//  FarmersMarketSocialMedia
//
//  Created by Paige Stephenson on 9/6/23.
//

import Foundation

struct Farm: Codable {
    
    var listingID: String
    var listingName: String
    var mediaWebsite: String?
    var locationState: String?
    var locationCity: String?
    var locationZipCode: String?
    
    var listingDescription: String?
    var briefDescription: String?
    var myDescription: String?

    var contactName: String?
    var contactPhone: String?
    
    var locationAddress: String?
    
    var listingImage: String?

    
    enum CodingKeys: String, CodingKey {
        case listingID = "listing_id"
        case listingName = "listing_name"
        case mediaWebsite = "media_website"
        case locationState = "location_state"
        case locationCity = "location_city"
        case locationZipCode = "location_zipcode"
        case listingDescription = "listing_desc"
        case briefDescription = "brief_desc"
        case myDescription = "mydesc"
        case contactName = "contact_name"
        case contactPhone = "contact_phone"
        case locationAddress = "location_address"
        case listingImage = "listing_image"
       
    }
}


struct SearchResponse: Codable {
    let data: [Farm]
}

