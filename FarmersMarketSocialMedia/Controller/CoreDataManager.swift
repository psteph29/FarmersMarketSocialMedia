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
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AppDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    static let shared = CoreDataManager()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Failed to save context: \(error)")
            }
        }
    }
    
    func saveFavorite(businessListing: BusinessListing) {
        let context = persistentContainer.viewContext
        let favoriteBusinessListing = FavoriteBusinessListing(context: context)
        
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
        
        saveContext()
    }
    
    func fetchFavorites() -> [FavoriteBusinessListing] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteBusinessListing> = FavoriteBusinessListing.fetchRequest()
        
        do {
            let favorites = try context.fetch(fetchRequest)
            return favorites
        } catch {
            print("Failed to fetch favorites: \(error)")
            return []
        }
    }
}

