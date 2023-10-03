//
//  UserBusinessProfileViewViewController.swift
//  FarmersMarketSocialMedia
//
//  Created by MJ Orton on 9/8/23.
//

import UIKit

class UserBusinessProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessAddressLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!

    @IBOutlet var favoriteButton: UIButton!
    
    @IBOutlet weak var postsTableView: UITableView!
    
    var businessListing: BusinessListing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessNameLabel.text = businessListing.listing_name
        businessAddressLabel.text = businessListing.listing_address
        descriptionTextView.text = businessListing.listing_description ?? "The farm has not listed a description"

        guard let url = URL(string: businessListing.listing_profileImageURL ?? "https://mediaproxy.salon.com/width/1200/https://media.salon.com/2021/08/farmers-market-produce-0812211.jpg") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error downloading image: \(error?.localizedDescription ?? "No error description")")
                return
            }
            DispatchQueue.main.async {
                // Set the downloaded image to the UIImageView
                self.profileImage.image = UIImage(data: data)
            }
        }
        task.resume()
        profileImage.alpha = 0.3
        profileImage.contentMode = .scaleAspectFill

    }
    
    init?(coder: NSCoder, businessListing: BusinessListing) {
        self.businessListing = businessListing
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
          CoreDataManager.shared.saveFavorite(businessListing: businessListing)
      }
  
}

