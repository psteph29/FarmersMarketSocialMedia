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
    // Tested and Successful.
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
                    guard
                        let listing_uuid = document.get("listing_uuid") as? String,
                        let listing_name = document.get("listing_name") as? String,
                        let listing_address = document.get("listing_address") as? String,
                        let listing_zipcode = document.get("listing_zipcode") as? Int
                    else {
                        print("Failed to parse document \(document.documentID) due to missing required fields")
                        return nil
                    }
                    
                    let listing_USDA_id = document.get("listing_USDA_id") as? Int
                    let listing_username = document.get("listing_username") as? String
                    let listing_description = document.get("listing_description") as? String
                    let app_generated = document.get("app_generated") as? Bool

                    return BusinessListing(
                        listing_USDA_id: listing_USDA_id,
                        listing_uuid: listing_uuid,
                        listing_name: listing_name,
                        listing_address: listing_address,
                        listing_zipcode: listing_zipcode,
                        listing_username: listing_username,
                        listing_description: listing_description,
                        app_generated: app_generated
                    )
                } ?? []

                completion(businessListings)
        }
    }
    // Create or POST
    // Tested and works.
    func createBusinessListing(businessListing: BusinessListing) {
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        
        let data: [String: Any] = [
            "listing_name": businessListing.listing_name,
            "listing_address": businessListing.listing_address,
            "listing_zipcode": businessListing.listing_zipcode,
            "listing_username": businessListing.listing_username ?? "Test username",
            "listing_description": businessListing.listing_description ?? "Test description",
            "app_generated": businessListing.app_generated ?? true
        ]
        
        ref = db.collection("USDAFarmersMarkets").addDocument(data: data) { error in
            if let error = error {
                print("Error adding document: \(error)")
                // Error
            } else {
                guard let docID = ref?.documentID else { return }
                   print("Document added with ID: \(docID)")
                   
                   // Update the document to set its listing_uuid field to the generated document ID
                   db.collection("USDAFarmersMarkets").document(docID).updateData(["listing_uuid": docID])
                // Handle success
            }
        }
    }
    
    // Update or PUT
    // Tested and successful.
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
    // Tested and works.
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
    // Tested and successful.
    func fetchPostsByBusinessListing(listingUUID: String, completion: @escaping ([Post]?) -> Void) {
        let db = Firestore.firestore()
        db.collection("USDAFarmersMarkets").document(listingUUID).collection("posts").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching posts: \(error)")
                completion(nil)
                return
            }
            
            let posts = snapshot?.documents.compactMap { document -> Post? in
                print("Attempting to map document: \(document.documentID)")
                if let post_description = document.get("description") as? String,
                   let timestamp = document.get("date") as? Timestamp {
                    let post_date = timestamp.dateValue()
                    let post_id = document.documentID
                    return Post(id: post_id, description: post_description, date: post_date)
                } else {
                    print("Failed to map document: \(document.documentID)")
                    return nil
                }
            }
            
            completion(posts)
        }
    }

    // Create or POST
    // Tested and Successful.
    func createPostForBusinessListing(listingUUID: String, post: Post) {
        let db = Firestore.firestore()

        let postData: [String: Any] = [
            "id": post.id,
            "description": post.description,
            "date": post.date
        ]
        
        db.collection("USDAFarmersMarkets").document(listingUUID).collection("posts").document(post.id).setData(postData) { error in
            if let error = error {
                print("Error adding post: \(error)")
            } else {
                print("Post added with ID: \(post.id)")
            }
        }
    }
    
    // Update or PUT
    // Tested and successful.
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
    // tested and successful.
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
