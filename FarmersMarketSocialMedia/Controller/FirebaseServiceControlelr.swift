//
//  FirebaseServiceController.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 9/15/23.
//

import Foundation
import Firebase

struct FirebaseService {
    
    // Beginning of businessListing API Calls
    // Fetch or GET
    static func fetchBusinessListing(zipcodesArray: [Int], completion: @escaping ([BusinessListing]?) -> Void) {
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
    
    // Create or POST
    func createBusinessListing(businessListing: BusinessListing) {
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        
        // Generate UUID string
        let generatedUUIDString = UUID().uuidString
        
        var data: [String: Any] = [
            "listing_uuid": generatedUUIDString,
            "listing_name": businessListing.listing_name,
            "listing_address": businessListing.listing_address,
            "listing_zipcode": businessListing.listing_zipcode,
            "listing_username": businessListing.listing_username ?? "Test username",
            "listing_description": businessListing.listing_description ?? "Test description",
            "app_generated": businessListing.app_generated ?? true
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
    }
    
    // Update or PUT
    func updateBusinessListing(businessListing: BusinessListing) {
        let db = Firestore.firestore()
        
        var data: [String: Any] = [
            "listing_name": businessListing.listing_name,
            "listing_address": businessListing.listing_address,
            "listing_zipcode": businessListing.listing_zipcode,
            "listing_username": businessListing.listing_username ?? "Test username",
            "listing_description": businessListing.listing_description ?? "Test description",
        ]
        
        db.collection("USDAFarmersMarkets").document(businessListing.listing_uuid).updateData(data) { error in
            if let error = error {
                print("Error updating business listing: \(error)")
            } else {
                print("Business listing updated.")
            }
        }
    }

    // Delete or DELETE
    func deleteBusinessListing(listingUUID: String) {
        let db = Firestore.firestore()
        
        db.collection("USDAFarmersMarkets").document(listingUUID).delete() { error in
            if let error = error {
                print("Error deleting business listing: \(error)")
            } else {
                print("Business listing deleted.")
            }
        }
    }
    // End of API calls for businessListings

    // Beginning of API calls for Posts by businessListings
    // Fetch or GET
    func fetchPostsByBusinessListing(listingUUID: String, completion: @escaping ([Post]?) -> Void) {
        let db = Firestore.firestore()
        db.collection("USDAFarmersMarkets").document(listingUUID).collection("posts").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching posts: \(error)")
                completion(nil)
                return
            }
            
            let posts = snapshot?.documents.compactMap { document -> Post? in
                if let post_description = document.get("description") as? String,
                   let post_date = document.get("date") as? Date {
                    let post_id = document.documentID
                    // Something for images, will need to figure this out.
                    return Post(id: post_id, description: post_description, date: post_date)
                }
                return nil
            } ?? []
            
            completion(posts)
        }
    }

    // Create or POST
    func createPostForBusinessListing(listingUUID: String, post: Post) {
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        
        let postData: [String: Any] = [
            "description": post.description,
            "date": Date.timeIntervalSinceReferenceDate
        ]
        
        ref = db.collection("USDAFarmersMarkets").document(listingUUID).collection("posts").addDocument(data: postData) { error in
            if let error = error {
                print("Error adding post: \(error)")
            } else {
                print("Post added with ID: \(ref!.documentID)")
            }
        }
    }
    
    // Update or PUT
    func updatePostForBusinessListing(listingUUID: String, post: Post) {
        let db = Firestore.firestore()
        
        let postData: [String: Any] = [
            "description": post.description,
            "date": post.date
            // Image will need to be figured out.
        ]
        
        db.collection("USDAFarmersMarkets").document(listingUUID).collection("posts").document(post.id).updateData(postData) { error in
            if let error = error {
                print("Error updating post: \(error)")
            } else {
                print("Post updated.")
            }
        }
    }

    // Delete or DELETE
    func deletePostForBusinessListing(listingUUID: String, postID: String) {
        let db = Firestore.firestore()
        
        db.collection("USDAFarmersMarkets").document(listingUUID).collection("posts").document(postID).delete() { error in
            if let error = error {
                print("Error deleting post: \(error)")
            } else {
                print("Post deleted.")
            }
        }
    }
    // End of API calls for Posts
    // End of API calls for custom firestore database.
}
