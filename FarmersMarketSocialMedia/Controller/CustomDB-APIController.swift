//
//  CustomDB-APIController.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 9/15/23.
//

import Foundation
import Firebase

struct FirebaseService {
    static func fetchFarmersMarkets(zipcodesArray: [Int], completion: @escaping ([BusinessListing]?) -> Void) {
        let db = Firestore.firestore()
        db.collection("USDAFarmersMarkets")
            .whereField("listing_zipcode", in: zipcodesArray)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching farmers markets: \(error)")
                    completion(nil)
                    return
                }
                
                let businessListings = snapshot?.documents.compactMap { document -> BusinessListing? in
                    if let listing_USDA_id = document.get("listing_USDA_id") as? Int?,
                       let listing_uuid = document.get("listing_uuid") as? String,
                       let listing_name = document.get("listing_name") as? String,
                       let listing_address = document.get("listing_address") as? String,
                       let listing_zipcode = document.get("listing_zipcode") as? Int,
                       let listing_username = document.get("listing_username") as? String,
                       let listing_description = document.get("listing_description") as? String,
                       let app_generated = document.get("app_generated") as? Bool
                        {
                        return BusinessListing(listing_USDA_id: listing_USDA_id, listing_uuid: listing_uuid, listing_name: listing_name, listing_address: listing_address, listing_zipcode: listing_zipcode, listing_username: listing_username, listing_description: listing_description, app_generated: app_generated)
                    } else {
                        print("Failed to parse document \(document.documentID)")
                    }
                    return nil
                } ?? []
                
                completion(businessListings)
        }
    }

    func createFarmersMarket(businessListing: BusinessListing) {
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        
        var data: [String: Any] = [
            "listing_name": businessListing.listing_name,
            "listing_zipcode": businessListing.listing_zipcode,
            
            
            // Add other properties as needed
        ]
        
        ref = db.collection("farmersMarkets").addDocument(data: data) { error in
            if let error = error {
                print("Error adding document: \(error)")
                // Error
            } else {
                print("Document added with ID: \(ref!.documentID)")
                // Handle success
            }
        }
        
        // create UUID() and assign it to a string and also to id property in struct
    }
    
    // Insert more here! :^)

}
