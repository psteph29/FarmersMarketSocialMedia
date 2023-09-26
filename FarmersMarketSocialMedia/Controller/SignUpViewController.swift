//
//  SignUpViewController.swift
//  FarmersMarketSocialMedia
//
//  Created by Paige Stephenson on 9/14/23.
//

// IMPORTANT!!! the following view needs to verify the passwords are the same before calling the sign up func and should also directly say thet the username is their email.

import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol BusinessNameDelegate: AnyObject {
    func didSelectBusinessName(_ name: String)
}

weak var businessNameDelegate: BusinessNameDelegate?


class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var businessName: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var createProfileButton: UIButton!
    
    
    @IBOutlet weak var imageUploadView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        backgroundImage.image = UIImage(named: "leaves")
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
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as?
                UIImage else { return }
        
        imageUploadView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    

//    In the SignUpViewController, you should put businessNameDelegate?.didSelectBusinessName(chosenName) at the point where the user has selected or entered their business name. This typically occurs in response to some user action like tapping a "Confirm" button or selecting a business name from a list. So, you would put it in the appropriate place within the SignUpViewController code where you have access to chosenName (the selected business name).
//    businessNameDelegate?.didSelectBusinessName(businessName)

    func extractZipCode(from address: String) -> Int? {
        let pattern = "\\b(\\d{5}(?:-\\d{4})?)\\b"
        let regex = try? NSRegularExpression(pattern: pattern)
        if let match = regex?.firstMatch(in: address, range: NSRange(address.startIndex..., in: address)) {
            let zipRange = Range(match.range(at: 1), in: address)!
            let zipString = String(address[zipRange])
            let fiveDigitZip = zipString.split(separator: "-")[0]
            return Int(fiveDigitZip)
        }
        return nil
    }
    
    @IBAction func createProfileTapped(_ sender: UIButton) {
        guard let email = userName.text, let pwd = password.text, !email.isEmpty, !pwd.isEmpty else {
            // Handle the case where fields are empty, possibly show an alert to the user.
            return
        }

        FirebaseService.signUp(email: email, password: pwd) { (success, uid, error) in
            if success, let uid = uid {
                print("User successfully registered with UID:", uid)

                // Upload the profile image
                FirebaseService.uploadImageToFirebase(image: self.imageUploadView.image) { imageResult in
                    switch imageResult {
                    case .success(let imageURL):
                        let businessListing = BusinessListing(
                            listing_profileImageURL: imageURL,
                            uid: uid,
                            listing_USDA_id: nil,
                            listing_uuid: UUID().uuidString,
                            listing_name: self.businessName.text ?? "",
                            listing_address: self.address.text ?? "",
                            listing_zipcode: self.extractZipCode(from: self.address.text ?? ""),
                            listing_username: self.userName.text,
                            listing_description: self.descriptionTextField.text,
                            app_generated: true // Assuming you add this property to BusinessListing
                        )

                        FirebaseService.createBusinessListing(businessListing: businessListing) { (listingSuccess, listingError) in
                            if listingSuccess {
                                self.performSegue(withIdentifier: "CreateProfileSuccessful", sender: self)
                                print("Business listing created successfully!")
                            } else {
                                print("Error creating business listing:", listingError?.localizedDescription ?? "Unknown error")
                            }
                        }

                    case .failure(let imageError):
                        print("Error uploading profile image:", imageError.localizedDescription)
                    }
                }

            } else {
                // Handle the registration error
                print("Error registering user:", error?.localizedDescription ?? "Unknown error")
            }
        }
    }
}
