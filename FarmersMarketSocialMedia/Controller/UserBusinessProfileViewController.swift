//
//  UserBusinessProfileViewViewController.swift
//  FarmersMarketSocialMedia
//
//  Created by MJ Orton on 9/8/23.
//

import UIKit

class UserBusinessProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessAddressLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet var favoriteButton: UIButton!
    
    @IBOutlet weak var postsTableView: UITableView!    
    
    var businessListing: BusinessListing
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
         super.viewDidLoad()
         
         setupUI()
         fetchProfileImage()
         fetchPosts()
         setupTableView()
     }
    
    init?(coder: NSCoder, businessListing: BusinessListing) {
        self.businessListing = businessListing
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
          CoreDataManager.shared.saveFavorite(businessListing: businessListing)
      }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserBusinessProfilePosts", for: indexPath) as! BusinessListingPostCell
        
        let post = posts[indexPath.row]
        
        cell.dateLabel?.text = post.date.description
        cell.descriptionLabel?.text = post.description
//        cell.postImage.loadImage(from: post.imageURL ?? "https://mediaproxy.salon.com/width/1200/https://media.salon.com/2021/08/farmers-market-produce-0812211.jpg")
        
        return cell
    }
    
    // Organizing the ui and other elements that used to be in the viewdidload moved into their own funcs below.
    
    private func setupUI() {
         businessNameLabel.text = businessListing.listing_name
         businessAddressLabel.text = businessListing.listing_address
         descriptionTextView.text = businessListing.listing_description ?? "The farm has not listed a description"
     }
     
     private func fetchProfileImage() {
         var validProfileImageURL: URL?
         
         if let imageURLString = businessListing.listing_profileImageURL,
            let potentialURL = URL(string: imageURLString),
            UIApplication.shared.canOpenURL(potentialURL) {
             validProfileImageURL = potentialURL
         } else {
             validProfileImageURL = URL(string: "https://mediaproxy.salon.com/width/1200/https://media.salon.com/2021/08/farmers-market-produce-0812211.jpg")
         }
         
         guard let finalURL = validProfileImageURL else {
             print("Invalid URL and fallback URL is also not working.")
             return
         }
         
         let task = URLSession.shared.dataTask(with: finalURL) { [weak self] data, response, error in
             guard let data = data, error == nil, let self = self else {
                 print("Error downloading image: \(error?.localizedDescription ?? "No error description")")
                 return
             }
             DispatchQueue.main.async {
                 self.profileImage.image = UIImage(data: data)
                 self.profileImage.alpha = 0.3
                 self.profileImage.contentMode = .scaleAspectFill
             }
         }
         task.resume()
     }
     
     private func setupTableView() {
         postsTableView.delegate = self
         postsTableView.dataSource = self
     }
    
    func fetchPosts() {
         // Attempt to fetch posts by listingUUID
         FirebaseService.fetchPostsByBusinessListing(listingUUID: businessListing.listing_uuid) { [weak self] fetchedPosts in
             guard let self = self else { return }
             
             if let fetchedPosts = fetchedPosts, !fetchedPosts.isEmpty {
                 self.posts = fetchedPosts
                 self.postsTableView.reloadData()
             } else {
                 // If fetching by listingUUID fails or returns no posts, attempt to fetch by userUID
                 // Assuming businessListing has a userUID property
                 FirebaseService.fetchPostsByUserUID(uid: self.businessListing.uid!) { fetchedPosts in
                     guard let fetchedPosts = fetchedPosts else {
                         print("Error fetching posts or no posts available.")
                         return
                     }
                     self.posts = fetchedPosts
                     self.postsTableView.reloadData()
                 }
             }
         }
     }
}
