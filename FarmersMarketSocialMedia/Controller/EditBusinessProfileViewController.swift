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
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var editDescriptionTextField: UITextView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImage.alpha = 0.3
        backgroundImage.contentMode = .scaleAspectFill
    }
    

}


// THE BELOW IS FOR REFERENCE.
//func updateBusinessListing(businessListing: BusinessListing) {
//    let db = Firestore.firestore()
//    
//    var data: [String: Any] = [
//        "listing_name": businessListing.listing_name,
//        "listing_address": businessListing.listing_address,
//        "listing_zipcode": businessListing.listing_zipcode as Any,
//        "listing_username": businessListing.listing_username ?? "Test username",
//        "listing_description": businessListing.listing_description ?? "Test description",
//    ]
//    
//    db.collection("USDAFarmersMarkets").document(businessListing.listing_uuid).updateData(data) { error in
//        if let error = error {
//            print("Error updating business listing: \(error)")
//        } else {
//            print("Business listing updated.")
//        }
//    }
//}

