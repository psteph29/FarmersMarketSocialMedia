//
//  SearchCollectionViewController.swift
//  FarmersMarketSocialMedia
//
//  Created by Paige Stephenson on 9/8/23.
//

import UIKit
import CoreLocation

class SearchCollectionViewController: UIViewController {
    
    let coreLocationManager = CoreLocationManager()

    @IBOutlet weak var zipCodeSearchBar: UISearchBar!
    @IBOutlet weak var radiusButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    let APIFarmController = APIController()
    var farms: [Farm] = []
    
    var businessListings: [BusinessListing] = []
    
    var selectedRadius: Int? = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // selectedRadius = 10
        zipCodeSearchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
        
        setupBackgroundImage()
        
        coreLocationManager.delegate = self
        coreLocationManager.requestLocation()
    }
    
    private func setupBackgroundImage() {
        backgroundImage.alpha = 0.3
        backgroundImage.contentMode = .scaleAspectFill
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
        // makes the list shrink if the user selects a shorter distance with less markets within the new radius
        self.businessListings = []
        
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
        print(nearbyZipCodes)

        // Convert nearby ZIP codes from String to Int
        let nearbyZipCodesInt = nearbyZipCodes.compactMap { Int($0) }
        
        // Split the nearbyZipCodesInt into chunks of 30 or fewer for the firestore api to handle
        let chunks = nearbyZipCodesInt.chunked(into: 30)
        
        // Create a dispatch group to handle multiple Firebase queries
        let group = DispatchGroup()
        
        for chunk in chunks {
            group.enter()  // Enter the group before each query
            
            FirebaseService.fetchBusinessListing(zipcodesArray: chunk) { listings in
                guard let listings = listings else {
                    print("Error fetching business listings")
                    group.leave()  // Leave the group if an error occurs
                    return
                }

                self.businessListings.append(contentsOf: listings)
                group.leave()  // Leave the group when the query completes
            }
        }
        
        // When all queries have completed
        group.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    }
    
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
    
    @IBSegueAction func viewBusiness(_ coder: NSCoder) -> UIViewController? {
        guard let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first,
                 selectedIndexPath.item < businessListings.count else {
               return nil
           }
           
           let selectedBusiness = businessListings[selectedIndexPath.item]
           return UserBusinessProfileViewController(coder: coder, businessListing: selectedBusiness)
    }
}

extension SearchCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadBusinessListings()
    }
}

// UICollectionViewDataSource and UICollectionViewDelegate Extension
extension SearchCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Number of Items: \(businessListings.count)")
        return businessListings.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchResultCell", for: indexPath) as! BusinessSearchResultsCollectionViewCell
        
        let businessListing = businessListings[indexPath.item]
        cell.businessNameLabel.text = businessListing.listing_name
//        cell.addressLabel.text = businessListing.listing_address
        
        let numberOfImages: UInt32 = 23
        let random = arc4random_uniform(numberOfImages)
        let imageName = "\(random)"
        
        if let imageURL = businessListing.listing_profileImageURL {
            cell.imageView.loadImage(from: imageURL)
        } else {
            cell.imageView.image = UIImage(named: imageName)
        }
        
        cell.onFavorite = {
            CoreDataManager.shared.saveFavorite(businessListing: businessListing)
        }
        
        return cell
    }
}

// This extension allows the SearchCollectionViewController to conform to the CoreLocationManagerDelegate protocol.
// This means it can handle location updates and errors from the CoreLocationManager.
extension SearchCollectionViewController: CoreLocationManagerDelegate {
    
    // This method is called when the CoreLocationManager successfully gets a ZIP code.
    func didUpdateZipCode(_ zipCode: String) {
        // Run UI-related updates on the main thread to ensure smooth UI performance.
        DispatchQueue.main.async {
            // Set the found ZIP code to the search bar's text.
            self.zipCodeSearchBar.text = zipCode
            
            // Load business listings based on the updated ZIP code.
            self.loadBusinessListings()
        }
    }
    
    // Displays an alert when location services are disabled or there's an error in accessing them.
    func showLocationServicesAlert() {
        let alert = UIAlertController(title: "Location Services Disabled",
                                      message: "Please enable Location Services in Settings or manually input your ZIP code.",
                                      preferredStyle: .alert)
        
        // Action for when the user clicks "OK", dismissing the alert.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Action for when the user clicks "Settings", which will take them to the app's settings in the Settings app.
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }))
        
        // Present the alert to the user.
        present(alert, animated: true, completion: nil)
    }
    
    // This method is called when the CoreLocationManager encounters an error.
    func didFailWithError(_ error: Error) {
        // Show the location services alert to inform the user.
        showLocationServicesAlert()
    }
}
