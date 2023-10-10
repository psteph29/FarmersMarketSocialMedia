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

        businessNameLabel.text = businessListing.listing_name
        businessAddressLabel.text = businessListing.listing_address
        descriptionTextView.text = businessListing.listing_description ?? "The farm has not listed a description"

        // Check if we have a valid profile image URL
        var validProfileImageURL: URL?

        if let imageURLString = businessListing.listing_profileImageURL,
           let potentialURL = URL(string: imageURLString),
           UIApplication.shared.canOpenURL(potentialURL) {
            validProfileImageURL = potentialURL
        } else {
            // If not, fall back to the default image URL
            validProfileImageURL = URL(string: "https://mediaproxy.salon.com/width/1200/https://media.salon.com/2021/08/farmers-market-produce-0812211.jpg")
        }

        guard let finalURL = validProfileImageURL else {
            print("Invalid URL and fallback URL is also not working.")
            return
        }

        let task = URLSession.shared.dataTask(with: finalURL) { data, response, error in
            guard let data = data, error == nil else {
                print("Error downloading image: \(error?.localizedDescription ?? "No error description")")
                return
            }
            DispatchQueue.main.async {
                // Set the downloaded image to the UIImageView
                self.profileImage.image = UIImage(data: data)
            }
        }
        task.resume()

        profileImage.alpha = 0.3
        profileImage.contentMode = .scaleAspectFill
        
        // Fetch posts by business listing
        FirebaseService.fetchPostsByBusinessListing(listingUUID: businessListing.listing_uuid) { fetchedPosts in
            guard let fetchedPosts = fetchedPosts else {
                print("Error fetching posts or no posts available.")
                return
            }
            self.posts = fetchedPosts
            self.postsTableView.reloadData()
        }
        
        // Set TableView Delegates
        postsTableView.delegate = self
        postsTableView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openAddressOptions))
        businessAddressLabel.isUserInteractionEnabled = true
        businessAddressLabel.addGestureRecognizer(tapGesture)
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
    
    func openInAppleMaps() {
        let address = businessListing.listing_address
        if let url = URL(string: "http://maps.apple.com/?address=\(address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func openInGoogleMaps() {
        let address = businessListing.listing_address
        if let url = URL(string: "comgooglemaps://?q=\(address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func openAddressOptions() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Option to open in Apple Maps
        actionSheet.addAction(UIAlertAction(title: "Open in Apple Maps", style: .default) { _ in
            self.openInAppleMaps()
        })
        
        // Option to open in Google Maps (if available)
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            actionSheet.addAction(UIAlertAction(title: "Open in Google Maps", style: .default) { _ in
                self.openInGoogleMaps()
            })
        }
        
        // Cancel option
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }

}
