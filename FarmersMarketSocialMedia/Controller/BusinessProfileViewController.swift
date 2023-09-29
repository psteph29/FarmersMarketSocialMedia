//
//  BusinessProfileViewViewController.swift
//  FarmersMarketSocialMedia
//
//  Created by MJ Orton on 9/8/23.
//

import UIKit

class BusinessProfileViewController: UIViewController {
    var userId: String?
    
    @IBOutlet weak var newPost: UIButton!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var businessAddress: UILabel!
    @IBOutlet var businessDescription: UITextView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true

        backgroundImage.alpha = 0.3
        backgroundImage.contentMode = .scaleAspectFill

        if let userIdFromDefaults = UserDefaults.standard.string(forKey: "UserId") {
              self.userId = userIdFromDefaults
          }
        
        // Call the method from FirebaseService
        FirebaseService.fetchBusinessListingByUID(uid: userId!) { [weak self] businessListing in
            guard let businessListing = businessListing else {
                // Handle error or empty business listing if necessary
                print("Error: Failed to fetch business listing.")
                return
            }
            
            DispatchQueue.main.async {
                self?.updateUI(with: businessListing)
            }
        }
    }

    func updateUI(with businessListing: BusinessListing) {
        businessNameLabel.text = businessListing.listing_name
        businessAddress.text = businessListing.listing_address
        businessDescription.text = businessListing.listing_description
         
         // Load profile image
        if let profileImageURLString = businessListing.listing_profileImageURL,
           let url = URL(string: profileImageURLString) {
            
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
            task.resume()  // Don't forget to resume the task
        }
     }
}
