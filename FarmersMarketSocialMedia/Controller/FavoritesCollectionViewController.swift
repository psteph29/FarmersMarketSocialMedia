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
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    let coreDataManager = CoreDataManager.shared
    var favoriteBusinessListings: [FavoriteBusinessListing] = []
    
    override func viewDidLoad() {
      super.viewDidLoad()

        loadFavorites()
        collectionView.collectionViewLayout = generateLayout()

        backgroundImage.alpha = 0.3
        backgroundImage.contentMode = .scaleAspectFill
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadFavorites()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func loadFavorites() {
        favoriteBusinessListings = coreDataManager.fetchFavorites()
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
        
        let numberOfImages: UInt32 = 23
        let random = arc4random_uniform(numberOfImages)
        let imageName = "\(random)"
        
        if let profileImageUrl = favoriteBusinessListing.listing_profileImageURL {
            cell.backgroundImageView.loadImage(from: profileImageUrl)
        } else {
            // Handle the case where profileImageUrl is nil or an invalid URL
            cell.backgroundImageView.image = UIImage(named: imageName) // or set a placeholder image
        }
        
        cell.onFavorite = {
            CoreDataManager.shared.removeFavorite(favoriteBusinessListing)
            self.loadFavorites()
            collectionView.reloadData()
        }
        return cell
    }
    
    @IBSegueAction func viewFavoriteListing(_ coder: NSCoder) -> UIViewController? {
        guard let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first,
                 selectedIndexPath.item < favoriteBusinessListings.count else {
               return nil
           }
           
        let selectedFavoriteBusiness = favoriteBusinessListings[selectedIndexPath.item]
        let business = BusinessListing(from: selectedFavoriteBusiness)
        return UserBusinessProfileViewController(coder: coder, businessListing: business)
    }
    
//    This is to test a git commit 
}
