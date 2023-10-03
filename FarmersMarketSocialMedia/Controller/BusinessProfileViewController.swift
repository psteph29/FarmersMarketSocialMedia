//
//  BusinessProfileViewViewController.swift
//  FarmersMarketSocialMedia
//
//  Created by MJ Orton on 9/8/23.
//

import UIKit
import FirebaseFirestore

class BusinessProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Array of posts
    var posts: [Post] = []
    
    // UID for usage
    var userId: String?
    
    @IBOutlet weak var newPost: UIButton!
    
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var businessAddress: UILabel!
    @IBOutlet var businessDescription: UITextView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var postTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newPost.addTarget(self, action: #selector(createPostTapped), for: .touchUpInside)

        
        postTableView.dataSource = self
        postTableView.delegate = self
        
        self.navigationItem.hidesBackButton = true

        backgroundImage.alpha = 0.3
        backgroundImage.contentMode = .scaleAspectFill

        if let userIdFromDefaults = UserDefaults.standard.string(forKey: "UserId") {
              self.userId = userIdFromDefaults
          }
        
        FirebaseService.fetchBusinessListingByUID(uid: userId!) { [weak self] businessListing in
            guard let businessListing = businessListing else {
                print("Error: Failed to fetch business listing.")
                return
            }
            
            DispatchQueue.main.async {
                self?.updateUI(with: businessListing)
            }
            self?.fetchPosts(for: businessListing.listing_uuid)
        }
   
    }
 
    @IBAction func createPostTapped(_ sender: UIButton) {
        print("button tapped")
        performSegue(withIdentifier: "toCreatePost", sender: self)
    }

    
    func fetchPosts(for listingUUID: String) {
        FirebaseService.fetchPostsByBusinessListing(listingUUID:
                                                        // Below is a forced uuid in order to load posts, as the post creation screen was unavailable to me
                                                        "0005bb92-a6c9-4781-85cd-2edc2cdecfec") { [weak self] fetchedPosts in
            guard let fetchedPosts = fetchedPosts else {
                print("Failed to fetch posts.")
                return
            }
            self?.posts = fetchedPosts
            DispatchQueue.main.async {
                print("Reloading table view")
                self?.postTableView.reloadData()
            }
        }
    }
    
    func updateUI(with businessListing: BusinessListing) {
        businessNameLabel.text = businessListing.listing_name
        businessAddress.text = businessListing.listing_address
        businessDescription.text = businessListing.listing_description

        if let profileImageURLString = businessListing.listing_profileImageURL,
           let url = URL(string: profileImageURLString) {
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error downloading image: \(error?.localizedDescription ?? "No error description")")
                    return
                }
                DispatchQueue.main.async {
                    self.profileImage.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! BusinessProfileTableViewCell
        
        let post = posts[indexPath.row]
        
        cell.dateLabel?.text = post.date.description
        cell.descriptionLabel?.text = post.description
        // load image somehow
        
        
        return cell
    }
     }
    
    @IBAction func addNewPost(_ sender: UIButton) {
        print("Button pressed")
    }
    
    @IBSegueAction func moveToNewPostPage(_ coder: NSCoder) -> UIViewController? {
        return CreatePostsViewController(coder: coder)
    }

    
}
