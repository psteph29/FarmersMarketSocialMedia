//
//  FavoritesCollectionViewController.swift
//  FarmersMarketSocialMedia
//
//  Created by Paige Stephenson on 9/15/23.
//

// Coder needs to be implemented here so a user can see more details about their favorite business listings
    
import UIKit
import CoreData

private let reuseIdentifier =  "favoritesCell"

class FavoritesCollectionViewController: UICollectionViewController {

    let coreDataManager = CoreDataManager.shared
    var favoriteBusinessListings: [FavoriteBusinessListing] = []
    
    override func viewDidLoad() {
      super.viewDidLoad()

      loadFavorites()
      
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func loadFavorites() {
        favoriteBusinessListings = coreDataManager.fetchFavorites()
//        let first = favoriteBusinessListings.first!
//        let favoriteListingIDs = coreDataManager.fetchFavorites()
        // favoriteBusinessListings = await loadBusinessListings(with: favoriteListingIDs)
        collectionView.reloadData()
    }

    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
        //        item size is set to full width of the group
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitem: item, count: 1)

        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20)
        section.interGroupSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteBusinessListings.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FavoritesCollectionViewCell

        let favoriteBusinessListing = favoriteBusinessListings[indexPath.item]
            
        if let listingName = favoriteBusinessListing.listing_name {
            cell.businessNameLabel.text = listingName
        } else {
            cell.businessNameLabel.text = "Name not available"
        }
        
          if let address = favoriteBusinessListing.listing_address {
              cell.addressLabel.text = address
          } else {
              cell.addressLabel.text = "Address not available"
          }
        
        if let profileImageUrl = favoriteBusinessListing.listing_profileImageURL {
            cell.backgroundImageView.loadImage(from: profileImageUrl)
        } else {
            // Handle the case where profileImageUrl is nil or an invalid URL
            cell.backgroundImageView.image = nil // or set a placeholder image
        }

        return cell
    }

}
