//
//  FavoriteBusinessListing+CoreDataProperties.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 9/22/23.
//
//

import Foundation
import CoreData


extension FavoriteBusinessListing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteBusinessListing> {
        return NSFetchRequest<FavoriteBusinessListing>(entityName: "FavoriteBusinessListing")
    }

    @NSManaged public var app_generated: Bool
    @NSManaged public var id: String?
    @NSManaged public var listing_address: String?
    @NSManaged public var listing_description: String?
    @NSManaged public var listing_name: String?
    @NSManaged public var listing_profileImageURL: String?
    @NSManaged public var listing_USDA_id: Int32
    @NSManaged public var listing_username: String?
    @NSManaged public var listing_uuid: String?
    @NSManaged public var listing_zipcode: Int32
    @NSManaged public var uid: String?

}

extension FavoriteBusinessListing : Identifiable {

}
