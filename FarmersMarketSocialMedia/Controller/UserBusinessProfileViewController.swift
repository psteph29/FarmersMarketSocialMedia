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

    @IBOutlet var businessDescriptionLabel: UILabel!
    
    @IBOutlet weak var postsTableView: UITableView!
    
    var businessListing: BusinessListing
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchProfileImage()
        fetchPosts()
        setupTableView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openAddressOptions))
            businessAddressLabel.isUserInteractionEnabled = true
            businessAddressLabel.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        BubbleManager.showBubble(over: businessAddressLabel, in: self.view)
    }
    
    init?(coder: NSCoder, businessListing: BusinessListing) {
        self.businessListing = businessListing
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        // Save the business listing as a favorite using Core Data
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
        
        cell.postImage.loadImage(from: post.imageURL ?? "https://mediaproxy.salon.com/width/1200/https://media.salon.com/2021/08/farmers-market-produce-0812211.jpg")
        
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

        
        // Organizing the ui and other elements that used to be in the viewdidload moved into their own funcs below.
        private func setupUI() {
            businessNameLabel.text = businessListing.listing_name
            businessAddressLabel.text = businessListing.listing_address
            
            if let addressText = businessAddressLabel.text {
                let underlineAttribute: [NSAttributedString.Key: Any] = [
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ]
                let underlinedAddress = NSAttributedString(string: addressText, attributes: underlineAttribute)
                businessAddressLabel.attributedText = underlinedAddress
            }

            if let description = businessListing.listing_description, !description.isEmpty {
                businessDescriptionLabel.text = description
                businessDescriptionLabel.isHidden = false
            } else {
                businessDescriptionLabel.isHidden = true
            }
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
                    // If fetching by listingUUID fails or returns no posts, attempt to fetch by users UID
                    if let uid = self.businessListing.uid {
                        FirebaseService.fetchPostsByUserUID(uid: uid) { fetchedPosts in
                            guard let fetchedPosts = fetchedPosts else {
                                print("Error fetching posts or no posts available.")
                                return
                            }
                            self.posts = fetchedPosts
                            self.postsTableView.reloadData()
                        }
                    } else {
                        print("UID is nil")
                    }
                    
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

