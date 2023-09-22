//
//  SearchCollectionViewController.swift
//  FarmersMarketSocialMedia
//
//  Created by Paige Stephenson on 9/8/23.
//

// some issues are arising from the mile selector, on some zipcodes only certain distances seem to work

import UIKit

class SearchCollectionViewController: UIViewController {
    
    @IBOutlet weak var zipCodeSearchBar: UISearchBar!
    @IBOutlet weak var radiusButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let APIFarmController = APIController()
    var farms: [Farm] = []
    
    var businessListings: [BusinessListing] = []
    
    var selectedRadius: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // selectedRadius = 10
        zipCodeSearchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
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
    
    // The below uses the USDA Api
//    func loadFarms() {
//        Task {
//            guard let actualRadius = selectedRadius else {
//                print("Selected radius is nil")
//                return
//            }
//            
//            do {
//                let fetchedFarms = try await APIFarmController.fetchFarms(zip: zipCodeSearchBar.text, radius: actualRadius)
//                print("Fetched farms: \(fetchedFarms)")
//                updateUI(with: fetchedFarms)
//            } catch {
//                print("Error fetching farms: \(error)")
//            }
//        }
//    }
    
    func loadZipcodesData() -> Data? {
        guard let url = Bundle.main.url(forResource: "UpdatedZIPCODES", withExtension: "json") else {
            print("Error: Couldn't find UpdatedZIPCODES.json in the bundle.")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print("Error: Couldn't load UpdatedZIPCODES.json from the bundle. \(error)")
            return nil
        }
    }

    func loadBusinessListings() {
        guard let actualRadius = selectedRadius else {
            print("Selected radius is nil")
            return
        }
        
        let distanceInKilometers = milesToKilometers(miles: Double(actualRadius))
        
        // Get the jsonData using the loadZipcodesData function.
        guard let jsonData = loadZipcodesData() else {
            print("Error: Couldn't load ZIP code data.")
            return
        }
        
        let nearbyZipCodes = findZipCodesWithinDistance(userZipcode: zipCodeSearchBar.text ?? "", travelDistance: distanceInKilometers, jsonData: jsonData)
        
        print("Nearby zip codes: \(nearbyZipCodes)")
        
        // Convert nearby ZIP codes from String to Int
        let nearbyZipCodesInt = nearbyZipCodes.compactMap { Int($0) }
        
        FirebaseService.fetchBusinessListing(zipcodesArray: nearbyZipCodesInt) { listings in
            guard let listings = listings else {
                
                print("Error fetching business listings")
                return
            }
            print("Fetched business listings count: \(listings.count)")

            self.businessListings = listings
            self.collectionView.reloadData()
        }
    }
    
//    func updateUI(with farms: [Farm]) {
//        print("Updating UI with farms: \(farms)")
//        self.farms = farms
//        collectionView.reloadData()
//    }
    
    func updateUI(with businessListings: [BusinessListing]) {
        print("Updating UI with farms: \(businessListings)")
        self.businessListings = businessListings
        collectionView.reloadData()
    }
    
    @IBAction func radiusButtonPressed(_ sender: UICommand) {
        
        let title = sender.title

        switch title {
        case "10 miles":
            selectedRadius = 10
        case "15 miles":
            selectedRadius = 15
        case "25 miles":
            selectedRadius = 25
        case "50 miles":
            selectedRadius = 50
        default:
            selectedRadius = 10
        }
    }
}

extension SearchCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //loadFarms()
        loadBusinessListings()
    }
}

// UICollectionViewDataSource and UICollectionViewDelegate Extension
extension SearchCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("Number of Items: \(farms.count)")
//        return farms.count
        print("Number of Items: \(businessListings.count)")
        return businessListings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchResultCell", for: indexPath) as! BusinessSearchResultsCollectionViewCell
        
//        let farm = farms[indexPath.item]
//        cell.businessNameLabel.text = farm.listingName
//        cell.addressLabel.text = farm.locationAddress
        
        let businessListing = businessListings[indexPath.item]
        cell.businessNameLabel.text = businessListing.listing_name
        cell.addressLabel.text = businessListing.listing_address
        
        return cell
    }
    
    
}
