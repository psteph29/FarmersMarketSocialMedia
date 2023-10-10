//
//  BusinessListingStruct.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 9/15/23.
//

import Foundation

struct BusinessListing: Identifiable, Encodable {
    var id: String { listing_uuid }
    
    var listing_profileImageURL: String? //
    var uid: String? //
    var listing_USDA_id: Int?
    var listing_uuid: String
    var listing_name: String
    var listing_address: String
    var listing_zipcode: Int?
    var listing_username: String?
    var listing_description: String?
    var app_generated: Bool?
}

extension BusinessListing {
    init(from favoriteListing: FavoriteBusinessListing) {
        self.listing_profileImageURL = favoriteListing.listing_profileImageURL ?? "No image available."
        self.uid = favoriteListing.uid ?? "No uid"
        self.listing_USDA_id = Int(favoriteListing.listing_USDA_id)
        self.listing_uuid = favoriteListing.listing_uuid!
        self.listing_name = favoriteListing.listing_name!
        self.listing_address = favoriteListing.listing_address!
        self.listing_zipcode = Int(favoriteListing.listing_zipcode)
        self.listing_description = favoriteListing.listing_description ?? "No description available."
        self.app_generated = favoriteListing.app_generated 
    }
}
