//
//  BusinessListingStruct.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 9/15/23.
//

import Foundation

struct BusinessListing: Identifiable, Encodable {
    var id: String { listing_uuid }
    
    var uid: String?
    var listing_USDA_id: Int?
    var listing_uuid: String
    var listing_name: String
    var listing_address: String
    var listing_zipcode: Int?
    var listing_username: String?
    var listing_description: String?
    var app_generated: Bool?
    // var listing_firestore_uid: not sure the type yet
    // var listing_image: also not sure how to type this property yet
}
