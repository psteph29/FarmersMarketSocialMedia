//
//  EditBusinessProfileViewController.swift
//  FarmersMarketSocialMedia
//
//  Created by MJ Orton on 9/8/23.
//

import UIKit

class EditBusinessProfileViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var editProfileLable: UIView!
    @IBOutlet weak var profilePictureLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var currentBusinessListing: BusinessListing?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImage.alpha = 0.3
        backgroundImage.contentMode = .scaleAspectFill
        // Fetch and display current business listing
         if let userId = UserDefaults.standard.string(forKey: "UserId") {
             FirebaseService.fetchBusinessListingByUID(uid: userId) { [weak self] (listing) in
                 if let listing = listing {
                     self?.currentBusinessListing = listing
                     self?.populateUIFields(with: listing)
                 }
             }
         }
    }
    
    func populateUIFields(with listing: BusinessListing) {
          businessNameTextField.text = listing.listing_name
          descriptionTextField.text = listing.listing_description
          //... populate other fields when theyre available from MJ
      }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
          guard let listingName = businessNameTextField.text, !listingName.isEmpty,
                let description = descriptionTextField.text, !description.isEmpty else {
              // Show alert if fields are empty
              let alert = UIAlertController(title: "Error", message: "Please make sure no fields are empty.", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default))
              self.present(alert, animated: true, completion: nil)
              return
          }
        
        // Create a modified business listing
        var updatedListing = currentBusinessListing
        updatedListing?.listing_name = listingName
        updatedListing?.listing_description = description
        //... update other fields
        
        if let updatedListing = updatedListing {
                FirebaseService.updateBusinessListing(businessListing: updatedListing)
        }
    }
}


