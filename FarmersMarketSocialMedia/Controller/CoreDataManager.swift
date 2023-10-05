//
//  CoreDataManager.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 9/22/23.
//

import Foundation
import CoreData
import UIKit

// Define a Core Data manager class.
class CoreDataManager {
    
    // Create a singleton instance of CoreDataManager.
    static let shared = CoreDataManager()
    
    // Lazy initialization of the persistent container.
    // This will create or load an SQLite database named "AppDataModel".
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AppDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            // Handle possible errors while loading the persistent store.
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // Method to save any changes in the managed object context to the persistent store.
    func saveContext() {
        let context = persistentContainer.viewContext
        // Check if there are any changes in the context.
        if context.hasChanges {
            do {
                // Attempt to save the changes.
                try context.save()
            } catch {
                // Handle possible errors while saving.
                fatalError("Failed to save context: \(error)")
            }
        }
    }
    
    // Method to save a business listing as a favorite.
    func saveFavorite(businessListing: BusinessListing) {
        let context = persistentContainer.viewContext
        let favoriteBusinessListing = FavoriteBusinessListing(context: context)
        
        // Potentially change coreData to only save id and then perform a fetch when trying to view collection view and pass that fetched info along to the modal or detailed view page for listing.
        
        // Mapping the attributes from businessListing to favoriteBusinessListing.
        favoriteBusinessListing.id = businessListing.id
        favoriteBusinessListing.listing_profileImageURL = businessListing.listing_profileImageURL
        favoriteBusinessListing.uid = businessListing.uid
        favoriteBusinessListing.listing_USDA_id = Int32(businessListing.listing_USDA_id ?? 0)
        favoriteBusinessListing.listing_uuid = businessListing.listing_uuid
        favoriteBusinessListing.listing_name = businessListing.listing_name
        favoriteBusinessListing.listing_address = businessListing.listing_address
        favoriteBusinessListing.listing_zipcode = Int32(businessListing.listing_zipcode ?? 0)
        favoriteBusinessListing.listing_username = businessListing.listing_username
        favoriteBusinessListing.listing_description = businessListing.listing_description ?? "No description available."
        favoriteBusinessListing.app_generated = businessListing.app_generated ?? false
        
        // Save the new favorite business listing to the persistent store.
        saveContext()
    }
    
    // Method to fetch all favorite business listings from the persistent store.
    func fetchFavorites() -> [FavoriteBusinessListing] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteBusinessListing> = FavoriteBusinessListing.fetchRequest()
        
        do {
            // Attempt to fetch the favorites.
            let favorites = try context.fetch(fetchRequest)
            return favorites
        } catch {
            // Handle possible errors while fetching.
            print("Failed to fetch favorites: \(error)")
            return []
        }
    }
}

