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
    
    static let shared = CoreDataManager()
    
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AppDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

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
    
//    create (CRUD)
    func saveFavorite(businessListing: BusinessListing) {
        // make sure busimness listing isn't already favorited
        // let currentFavorites = fetchFavorites()
        // guard !currentFavorites.contains(wherer: { $0.id == businessListing.id }) else { return }
        let context = persistentContainer.viewContext
        let favoriteBusinessListing = FavoriteBusinessListing(context: context)
        
        favoriteBusinessListing.id = businessListing.id
//        favoriteBusinessListing.listing_profileImageURL = businessListing.listing_profileImageURL
//        favoriteBusinessListing.uid = businessListing.uid
//        favoriteBusinessListing.listing_USDA_id = Int32(businessListing.listing_USDA_id ?? 0)
//        favoriteBusinessListing.listing_uuid = businessListing.listing_uuid
//        favoriteBusinessListing.listing_name = businessListing.listing_name
//        favoriteBusinessListing.listing_address = businessListing.listing_address
//        favoriteBusinessListing.listing_zipcode = Int32(businessListing.listing_zipcode ?? 0)
//        favoriteBusinessListing.listing_username = businessListing.listing_username
//        favoriteBusinessListing.listing_description = businessListing.listing_description ?? "No description available."
//        favoriteBusinessListing.app_generated = businessListing.app_generated ?? false
        
        saveContext()
    }
//    delete (CRUD)
    func removeFavorite(_ favorite: FavoriteBusinessListing) {
        let context = persistentContainer.viewContext
        context.delete(favorite)
        saveContext()
    }
//    read (CRUD)
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

