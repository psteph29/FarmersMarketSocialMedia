//
//  SearchCollectionViewController.swift
//  FarmersMarketSocialMedia
//
//  Created by Paige Stephenson on 9/8/23.
//

import UIKit

class SearchCollectionViewController: UIViewController {
    
    @IBOutlet weak var zipCodeSearchBar: UISearchBar!
    @IBOutlet weak var radiusButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let APIFarmController = APIController()
    var farms: [Farm] = []
    
    var selectedRadius: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        selectedRadius = 10
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
    
    
    func loadFarms() {
        Task {
            guard let actualRadius = selectedRadius else {
                print("Selected radius is nil")
                return
            }
            
            do {
                let fetchedFarms = try await APIFarmController.fetchFarms(zip: zipCodeSearchBar.text, radius: actualRadius)
                print("Fetched farms: \(fetchedFarms)")
                updateUI(with: fetchedFarms)
            } catch {
                print("Error fetching farms: \(error)")
            }
        }
    }
    
    
    func updateUI(with farms: [Farm]) {
        print("Updating UI with farms: \(farms)")
        self.farms = farms
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
        loadFarms()
    }
    
}

// UICollectionViewDataSource and UICollectionViewDelegate Extension
extension SearchCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Number of Items: \(farms.count)")
        return farms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchResultCell", for: indexPath) as! BusinessSearchResultsCollectionViewCell
        
        let farm = farms[indexPath.item]
        cell.businessNameLabel.text = farm.listingName
        cell.addressLabel.text = farm.locationAddress
        
        return cell
    }
    
    
}

