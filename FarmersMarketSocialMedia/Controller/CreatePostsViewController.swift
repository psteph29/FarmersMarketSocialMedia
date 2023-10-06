//
//  CreatePostsViewController.swift
//  FarmersMarketSocialMedia
//
//  Created by MJ Orton on 9/8/23.
//

import UIKit

class CreatePostsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var createPostLabel: UILabel!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var postDescriptionTextField: UITextView!
    @IBOutlet weak var leavesBackground: UIImageView!

    @IBOutlet var uploadedImage: UIImageView!

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var imageUploadView: UIImageView!
    
    @IBOutlet weak var addPhotoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImage.alpha = 0.3
        backgroundImage.contentMode = .scaleAspectFill
        // Do any additional setup after loading the view.
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
    


    @IBAction func postButtonTapped(_ sender: UIButton) {
        guard let postDescription = postDescriptionTextField.text, !postDescription.isEmpty else {
            print("Error: Post description is empty!")
            return
        }

        let post = Post(
            id: "",  // Will update after saving to Firestore
            description: postDescription,
            date: Date(),
            imageURL: nil
        )

        if let postImage = imageUploadView.image {
            FirebaseService.uploadImageToFirebase(image: postImage) { [weak self] result in
                switch result {
                case .success(let imageUrl):
                    var postWithImage = post
                    postWithImage.imageURL = imageUrl
                    FirebaseService.createPostForBusinessUser(post: postWithImage)
                case .failure(let error):
                    print("Error uploading image: \(error)")
                }
            }
        } else {
            FirebaseService.createPostForBusinessUser(post: post)
        }
    }
}

