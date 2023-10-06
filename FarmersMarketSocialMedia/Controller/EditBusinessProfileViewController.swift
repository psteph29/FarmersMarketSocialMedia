//
//  EditBusinessProfileViewController.swift
//  FarmersMarketSocialMedia
//
//  Created by MJ Orton on 9/8/23.
//

import UIKit

class EditBusinessProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    weak var delegate: EditBusinessProfileDelegate?
    
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
    
    var currentBusinessListing: BusinessListing?
    
    @IBOutlet weak var cancelEditingProfileButton: UIButton!
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
        editDescriptionTextField.text = listing.listing_description
        businessAddressTextField.text = listing.listing_address
        profileImage.loadImage(from: listing.listing_profileImageURL ?? "https://png.pngtree.com/png-vector/20210609/ourmid/pngtree-mountain-network-placeholder-png-image_3423368.jpg")

    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let listingName = businessNameTextField.text, !listingName.isEmpty,
              let description = editDescriptionTextField.text, !description.isEmpty,
              let listingAddress = businessAddressTextField.text, !listingAddress.isEmpty
            // determine how to store image value?
        else {
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
        updatedListing?.listing_address = listingAddress
      //  updatedListing?.listing_profileImageURL = // post image to firebase storage, retrieve the link and store it here
        
        if let updatedListing = updatedListing {
            FirebaseService.updateBusinessListing(businessListing: updatedListing) { success in
                if success {
                    self.delegate?.didUpdateProfile()
                    // Dismiss the modal on successful update
                    self.dismiss(animated: true, completion: nil)
                } else {
                    // Optionally show an error message here if the update failed
                }
            }
        }
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
}

protocol EditBusinessProfileDelegate: AnyObject {
    func didUpdateProfile()
}
