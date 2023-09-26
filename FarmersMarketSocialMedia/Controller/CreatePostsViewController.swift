//
//  CreatePostsViewController.swift
//  FarmersMarketSocialMedia
//
//  Created by MJ Orton on 9/8/23.
//

import UIKit

class CreatePostsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, BusinessNameDelegate {
    
    @IBOutlet weak var createPostLabel: UILabel!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var postDescriptionTextField: UITextView!
    @IBOutlet weak var leavesBackground: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var imageUploadView: UIImageView!
    
    @IBOutlet weak var addPhotoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImage.alpha = 0.3
        backgroundImage.contentMode = .scaleAspectFill
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func postButtonTapped(_ sender: Any) {
        // Get the post description from postDescriptionTextField
        let postDescription = postDescriptionTextField.text ?? ""
        
        // Get the selected/taken photo from imageUploadView
        
        // Call createPostForBusinessListing with postDescription and photo data
//        createPostForBusinessListing(description: postDescription, photo: selectedImage)
        
        // Update UITableViews in "BusinessProfile" and "UserBusinessProfile" views
        // (Implement data communication or delegation between views)
        
        // Dismiss this view controller or perform any other necessary actions
    }
    
    @IBAction func cancelPostButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadImage(_ sender: Any) {
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
        
        alertController.popoverPresentationController?.sourceView = sender as! UIView
        
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as?
                UIImage else { return }
        
        imageUploadView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    func createPostForBusinessListing(description: String, photo: UIImage?) {
            // Implement your logic to create a new post
            // You can use the description and photo to create the post
            // Call the necessary functions to save the post data
        }
    
    func didSelectBusinessName(_ name: String) {
        businessNameLabel.text = name
    }

//    THIS CODE IS FOR CHANGING THE BUSINESS NAME LABEL TO WHATEVER THE BUSINESS NAME IS WHEN THEY SIGN UP!!!!
//    let signUpViewController = SignUpViewController() // Instantiate your SignUpViewController
//    signUpViewController.businessNameDelegate = self // Set the delegate
//    self.navigationController?.pushViewController(signUpViewController, animated: true) // Push the SignUpViewController onto the navigation stack
//
//    signUpViewController.businessNameDelegate = self
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
