//
//  FirebaseServiceController.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 9/15/23.
//

import Foundation
import Firebase
import FirebaseStorage

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
                        let listing_address = document.get("listing_address") as? String
                    else {
                        print("Failed to parse document \(document.documentID) due to missing required fields")
                        return nil
                    }
                    
                    let id = document.get("id") as? String
                    let uid = document.get("uid") as? String
                    let listing_zipcode = document.get("listing_zipcode") as? Int
                    let listing_profileImageURL = document.get("listing_profileImageURL") as? String
                    let listing_USDA_id = document.get("listing_USDA_id") as? Int
                    let listing_username = document.get("listing_username") as? String
                    let listing_description = document.get("listing_description") as? String
                    let app_generated = document.get("app_generated") as? Bool

                    return BusinessListing(
                        listing_profileImageURL: listing_profileImageURL,
                        uid: uid,
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
    
    // fetch or GET by uid for business profiles by business user
    // Tested and successful
    static func fetchBusinessListingByUID(uid: String, completion: @escaping (BusinessListing?) -> Void) {
        let db = Firestore.firestore()
        // Target the specific document by its uid
        db.collection("USDAFarmersMarkets").document(uid).getDocument { (documentSnapshot, error) in
          if let error = error {
            print("Error fetching business listing: \(error)")
            completion(nil)
            return
          }
          guard let document = documentSnapshot, document.exists else {
            print("Document with uid \(uid) does not exist")
            completion(nil)
            return
          }
          // Extract business listing details from the document
            guard
                let listing_uuid = document.get("listing_uuid") as? String,
                let listing_name = document.get("listing_name") as? String,
                let listing_address = document.get("listing_address") as? String
            else {
            print("Failed to parse document \(document.documentID) due to missing required fields")
            completion(nil)
            return
          }
            let id = document.get("id") as? String
            let uid = document.get("uid") as? String
            let listing_zipcode = document.get("listing_zipcode") as? Int
            let listing_profileImageURL = document.get("listing_profileImageURL") as? String
            let listing_USDA_id = document.get("listing_USDA_id") as? Int
            let listing_username = document.get("listing_username") as? String
            let listing_description = document.get("listing_description") as? String
            let app_generated = document.get("app_generated") as? Bool
            
        let businessListing = BusinessListing(
            listing_profileImageURL: listing_profileImageURL,
            uid: uid,
            listing_USDA_id: listing_USDA_id,
            listing_uuid: listing_uuid,
            listing_name: listing_name,
            listing_address: listing_address,
            listing_zipcode: listing_zipcode,
            listing_username: listing_username,
            listing_description: listing_description,
            app_generated: app_generated
          )
          completion(businessListing)
        }
      }
    
    // Create or POST
    // Tested and works.
    static func createBusinessListing(businessListing: BusinessListing, completion: @escaping (Bool, Error?) -> Void) {
        let db = Firestore.firestore()
        let data: [String: Any] = [
            "listing_profileImageURL": businessListing.listing_profileImageURL,
            "listing_uuid": businessListing.listing_uuid,
            "uid": businessListing.uid as Any,
            "listing_name": businessListing.listing_name,
            "listing_address": businessListing.listing_address,
            "listing_zipcode": businessListing.listing_zipcode as Any,
            "listing_username": businessListing.listing_username ?? "",
            "listing_description": businessListing.listing_description ?? "",
            "app_generated": businessListing.app_generated ?? true
        ]

        db.collection("USDAFarmersMarkets").document(businessListing.uid!).setData(data) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
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
            "listing_zipcode": businessListing.listing_zipcode as Any,
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
            "date": post.date,
            "image": post.imageURL as Any // Added the image reference here
        ]
        
        db.collection("USDAFarmersMarkets").document(listingUUID).collection("posts").document(post.id).setData(postData) { error in
            if let error = error {
                print("Error adding post: \(error)")
            } else {
                print("Post added with ID: \(post.id) and ImageURL: \(post.imageURL ?? "No ImageURL")")
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
    
    // Begining of API calls to storage
    
    // Upload or POST image to storage
    // Tested and successful.
    static func uploadImageToFirebase(image: UIImage?, completion: @escaping (Result<String, Error>) -> Void) {
        guard let image = image else {
            completion(.failure(NSError(domain: "No Image Found", code: -1, userInfo: nil)))
            return
        }

        guard let data = image.jpegData(compressionQuality: 1.0) else {
            completion(.failure(NSError(domain: "Failed to convert image to data", code: -2, userInfo: nil)))
            return
        }

        let storageRef = Storage.storage().reference().child("uploadedImages/\(UUID().uuidString).jpg")
        storageRef.putData(data, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                completion(.failure(error ?? NSError(domain: "Error uploading image", code: -3, userInfo: nil)))
                return
            }

            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    completion(.failure(error ?? NSError(domain: "Error getting download URL", code: -4, userInfo: nil)))
                    return
                }
                print("Image uploaded successfully. Download URL: \(downloadURL)")
                completion(.success(downloadURL.absoluteString))
            }
        }
    }

    // Update or PUT image request
    func updateImageInFirebase(oldImageURL: String?, newImage: UIImage?, for listingUUID: String, completion: @escaping (Result<String?, Error>) -> Void) {
        // First, delete the old image if it exists
        if let oldImageURL = oldImageURL {
            let oldStorageRef = Storage.storage().reference(forURL: oldImageURL)
            oldStorageRef.delete { error in
                if let error = error {
                    print("Error deleting old image: \(error)")
                    completion(.failure(error))
                    return
                }
                print("Old image successfully deleted.")
                
                // After deleting the old image, upload the new one
                FirebaseService.uploadImageToFirebase(image: newImage) { imageResult in
                    switch imageResult {
                    case .success(let imageURL):
                        completion(.success(imageURL))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        } else {
            // If there was no old image, just upload the new one
            FirebaseService.uploadImageToFirebase(image: newImage) { imageResult in
                switch imageResult {
                case .success(let imageURL):
                    completion(.success(imageURL))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }


    // Delete or DELETE image
    func deleteImageFromFirebase(imageURL: String, completion: @escaping (Bool) -> Void) {
        let storageRef = Storage.storage().reference(forURL: imageURL)
        
        storageRef.delete { error in
            if let error = error {
                print("Error deleting image: \(error)")
                completion(false)
            } else {
                print("Image successfully deleted.")
                completion(true)
            }
        }
    }
    // End of API calls for storage.
    
    // Beginning of API calls for authorization
    
    // Sign in
    // Altered for returning the uid of the signed in user for businesslisting lookup.
    static func signIn(email: String, password: String, completion: @escaping (Bool, String?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, nil, error)
                return
            }
            if let uid = authResult?.user.uid {
                completion(true, uid, nil)
            } else {
                // This is an unlikely scenario but added for completeness.
                completion(false, nil, NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve UID"]))
            }
        }
    }

    
    // Sign up
    // Altered for returning the uid of the newly signed in user for businesslisting lookup.
    static func signUp(email: String, password: String, completion: @escaping (Bool, String?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, nil, error)
                return
            }
            if let uid = authResult?.user.uid {
                completion(true, uid, nil)
            } else {
                // This is an unlikely scenario but added for completeness.
                completion(false, nil, NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve UID"]))
            }
        }
    }
    
    // READ BELOW!!!
    // IMPORTANT!!! The uid could be used from either sign in or up and stored temporaroily in the user defaults as a way to look up the business information while on other screens. IMPORTANT!!!
    // READ ABOVE!!!

    // End of auth API calls.
    // End of all API calls.
}
