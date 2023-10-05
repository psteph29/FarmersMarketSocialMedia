//
//  CreatePostsViewController.swift
//  FarmersMarketSocialMedia
//
//  Created by MJ Orton on 9/8/23.
//

import UIKit

class CreatePostsViewController: UIViewController {
    
    @IBOutlet weak var createPostLabel: UILabel!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var postDescriptionTextField: UITextView!
    @IBOutlet weak var leavesBackground: UIImageView!
    
    @IBOutlet var uploadedImage: UIImageView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImage.alpha = 0.3
        backgroundImage.contentMode = .scaleAspectFill
        // Do any additional setup after loading the view.
    }
    
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

        if let postImage = uploadedImage.image {
            FirebaseService.uploadImageToFirebase(image: postImage) { [weak self] result in
                switch result {
                case .success(let imageUrl):
                    var postWithImage = post
                    postWithImage.imageURL = imageUrl
                    if let newID = FirebaseService.createPostForBusinessUser(post: postWithImage) {
                        // Here you can update the post ID if you want to keep the post object around.
                    }
                case .failure(let error):
                    print("Error uploading image: \(error)")
                }
            }
        } else {
            if let newID = FirebaseService.createPostForBusinessUser(post: post) {
                // Update the post ID here if needed.
            }
        }
    }
}

