//
//  CoreDataManager.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 9/22/23.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    // Create a singleton instance of CoreDataManager.
    static let shared = CoreDataManager()
    
    private init() { }
    
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

    // create (CRUD) Method to save a business listing as a favorite.
    func saveFavorite(businessListing: BusinessListing) {
        let context = persistentContainer.viewContext
        
        // Check if the business listing is already favorited
        let fetchRequest: NSFetchRequest<FavoriteBusinessListing> = FavoriteBusinessListing.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", businessListing.id as CVarArg)
        
        do {
            let existingFavorites = try context.fetch(fetchRequest)
            // If the fetch results in any objects, the listing is already favorited
            if existingFavorites.count > 0 {
                print("Business listing is already favorited.")
                return
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return
        }
        
        // If the listing isn't already favorited, proceed with the save
        let favoriteBusinessListing = FavoriteBusinessListing(context: context)
        
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

    // delete (CRUD)
    func removeFavorite(_ favorite: FavoriteBusinessListing) {
        let context = persistentContainer.viewContext
        context.delete(favorite)
        saveContext()
    }
    
    // read (CRUD) Method to fetch all favorite business listings from the persistent store.
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
    
    // check if a cell is favorited
    func isFavorited(_ businessListingId: String) -> Bool {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteBusinessListing> = FavoriteBusinessListing.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", businessListingId)

      let count = (try? context.count(for: fetchRequest)) ?? 0
      return count > 0
    }
    
    // fetch a single favorite for the search result controller
    func fetchFavorite(by businessListingId: String) -> FavoriteBusinessListing? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteBusinessListing> = FavoriteBusinessListing.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", businessListingId)
        fetchRequest.fetchLimit = 1

        do {
            let fetchedFavorites = try context.fetch(fetchRequest)
            return fetchedFavorites.first
        } catch {
            print("Failed to fetch favorite by ID: \(businessListingId), error: \(error)")
            return nil
        }
    }

}
