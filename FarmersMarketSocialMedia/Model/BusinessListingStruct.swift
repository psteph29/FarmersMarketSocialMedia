//
//  BusinessListingStruct.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 9/15/23.
//

import Foundation

// Properties will need to be changed to the actual desired names, couldnt remember as of now.

struct BusinessListing: Identifiable, Encodable {
    var id: String { listing_uuid }
    
    var listing_USDA_id: Int?
    var listing_uuid: String
    var listing_name: String
    var listing_address: String
    var listing_zipcode: Int
    var listing_username: String?
   // var listing_firestore_uid: not sure the type yet
    var listing_description: String?
    var app_generated: Bool?
   // var listing_image: also not sure how to type this property yet
}
