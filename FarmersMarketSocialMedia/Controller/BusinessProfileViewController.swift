//
//  BusinessProfileViewViewController.swift
//  FarmersMarketSocialMedia
//
//  Created by MJ Orton on 9/8/23.
//

import UIKit
import FirebaseFirestore

class BusinessProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EditBusinessProfileDelegate, CreatePostDelegate {
    
    weak var delegate: EditBusinessProfileDelegate?
    
    
    
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
          
          setupNewPostButton()
          setupTableView()
          setupNavigationItem()
          setupBackgroundImage()
          setupUserId()
          fetchBusinessListingAndPosts()
      }
    
    private func setupNewPostButton() {
        newPost.addTarget(self, action: #selector(createPostTapped), for: .touchUpInside)
    }
    
    private func setupTableView() {
        postTableView.dataSource = self
        postTableView.delegate = self
    }
    
    private func setupNavigationItem() {
        self.navigationItem.hidesBackButton = true
    }
    
    private func setupBackgroundImage() {
        backgroundImage.alpha = 0.3
        backgroundImage.contentMode = .scaleAspectFill
    }
    
    private func setupUserId() {
        if let userIdFromDefaults = UserDefaults.standard.string(forKey: "UserId") {
            self.userId = userIdFromDefaults
        }
    }
    
    private func fetchBusinessListingAndPosts() {
        guard let userId = userId else {
            print("Error: UserId is nil.")
            return
        }
        
        FirebaseService.fetchBusinessListingByUID(uid: userId) { [weak self] businessListing in
            guard let businessListing = businessListing else {
                print("Error: Failed to fetch business listing.")
                return
            }
            
            DispatchQueue.main.async {
                self?.updateUI(with: businessListing)
            }
            print(businessListing.listing_uuid)
            self?.fetchPosts()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editVC = segue.destination as? EditBusinessProfileViewController {
            editVC.delegate = self
        }
    }
 
    @IBAction func createPostTapped(_ sender: UIButton) {
        print("button tapped")
        performSegue(withIdentifier: "toCreatePost", sender: self)
    }

    func fetchPosts() {
        print(userId ?? "No userID")
        FirebaseService.fetchPostsByUserUID(uid: userId!) { [weak self] fetchedPosts in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! BusinessListingPostCell
        
        let post = posts[indexPath.row]
        
        cell.dateLabel?.text = post.date.description
        cell.descriptionLabel?.text = post.description
        cell.postImage.loadImage(from: post.imageURL ?? "https://mediaproxy.salon.com/width/1200/https://media.salon.com/2021/08/farmers-market-produce-0812211.jpg")
        
        return cell
    }
     
    
    @IBAction func addNewPost(_ sender: UIButton) {
        print("Button pressed")
    }
    
    @IBSegueAction func moveToNewPostPage(_ coder: NSCoder) -> UIViewController? {
        let createPostVC = CreatePostsViewController(coder: coder)
        createPostVC?.delegate = self
        return createPostVC
    }
    
    func didCreatePost() {
        // Fetch the latest posts after a new one has been created
        fetchPosts()
        postTableView.reloadData()

        // Optionally show an alert
        let alert = UIAlertController(title: "Success", message: "Your post was created successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

extension BusinessProfileViewController {
    func didUpdateProfile() {
        // Re-fetch and update your UI
        FirebaseService.fetchBusinessListingByUID(uid: userId!) { [weak self] businessListing in
            guard let businessListing = businessListing else {
                print("Error: Failed to fetch business listing.")
                return
            }
            
            DispatchQueue.main.async {
                self?.updateUI(with: businessListing)
            }
            self?.fetchPosts()
        }
    }
}
