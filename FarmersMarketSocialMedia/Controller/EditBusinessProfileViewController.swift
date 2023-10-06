//
//  EditBusinessProfileViewController.swift
//  FarmersMarketSocialMedia
//
//  Created by MJ Orton on 9/8/23.
//

import UIKit

class EditBusinessProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var editProfileLable: UIView!
    @IBOutlet weak var profilePictureLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var editDescriptionTextField: UITextView!
    @IBOutlet weak var businessAddressLabel: UILabel!
    
    @IBOutlet weak var businessAddressTextField: UITextField!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var cancelEditingProfileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let userProfile = userProfile {
//            profileImage.image = userProfile.profileImage
//            businessNameTextField.text = userProfile.businessName
//            editDescriptionTextField.text = userProfile.profileDescription
//            businessAddressTextField.text = userProfile.businessAddress
//        }

        backgroundImage.alpha = 0.3
        backgroundImage.contentMode = .scaleAspectFill
    }
    
    @IBAction func uploadImage(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        
        alertController.popoverPresentationController?.sourceView = sender
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func cancelEditingProfile(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as?
                UIImage else { return }
        
        profileImage.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        // Update the user's profile data with the changes
//        userProfile?.profileImage = profileImage.image
//        userProfile?.businessName = businessNameTextField.text ?? ""
//        userProfile?.profileDescription = editDescriptionTextField.text ?? ""
//        userProfile?.businessAddress = businessAddressTextField.text ?? ""
        
        // Call a function to save the changes (e.g., to Firebase)
        saveUserProfileChanges()
        
        // Dismiss this view controller and return to BusinessProfileViewController
        self.dismiss(animated: true, completion: nil)
    }
    
    // Function to save user profile changes to Firebase or your data store
    func saveUserProfileChanges() {
        // Implement code to save the updated user profile to your backend or data store
        // You should handle any networking or data storage operations here
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

