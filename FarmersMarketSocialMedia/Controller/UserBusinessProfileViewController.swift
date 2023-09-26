//
//  UserBusinessProfileViewViewController.swift
//  FarmersMarketSocialMedia
//
//  Created by MJ Orton on 9/8/23.
//

import UIKit

class UserBusinessProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessAddressLabel: UILabel!

    @IBOutlet weak var businessProfileDescription: UITextView!

    @IBOutlet weak var contactInformation: UILabel!
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!

    
    @IBOutlet weak var postsTableView: UITableView!
    
    var businessListing: BusinessListing
    
    @IBOutlet weak var tableView: UITableView!

    var posts: [Post] = []
    var user: BusinessUserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchPostsByBusinessListing()
        // Call your function to fetch posts
        
        if let user = user {
            profileImage.image = user.profileImage
            businessNameLabel.text = user.businessName
            businessAddressLabel.text = user.businessAddress
            businessProfileDescription.text = user.profileDescription
        }
        businessNameLabel.text = businessListing.listing_name
        businessAddressLabel.text = businessListing.listing_address

        descriptionTextView.text = businessListing.listing_description ?? "The farm has not listed a description"

        descriptionTextView.text = businessListing.listing_description
//        contactInformation.text = businessListing
//        email.text = businessListing
        
        
//        profileImage.load(url: URL(businessListing.listing_profileImageURL))
        
        guard let url = URL(string: businessListing.listing_profileImageURL!) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error downloading image: \(error?.localizedDescription ?? "No error description")")
                return
            }
            DispatchQueue.main.async {
                // Set the downloaded image to your UIImageView
                self.profileImage.image = UIImage(data: data)
            }
        }
        task.resume()
        profileImage.alpha = 0.3
        profileImage.contentMode = .scaleAspectFill

    }

    func fetchPostsByBusinessListing() {
        FirebaseService.shared.fetchPostsByBusinessListing { [weak self] result in
            switch result {
            case .success(let fetchedPosts):
                // Update your data source (e.g., self.posts) with fetched posts
                self?.posts = fetchedPosts
                
                // Reload the table view to display the new data
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                // Handle the error, e.g., show an alert
                print("Failed to fetch posts: \(error)")
            }
        }
    }
    
    func updateUserProfile() {
        // Assuming you have references to UI elements for updating profile data
        let updatedImage = profileImage.image
        let updatedName = businessNameLabel.text ?? ""
        let updatedAddress = businessAddressLabel.text ?? ""
        let updatedDescription = businessProfileDescription.text ?? ""

        // Update the user object with the new data
        user?.profileImage = updatedImage
        user?.businessName = updatedName
        user?.businessAddress = updatedAddress
        user?.profileDescription = updatedDescription

        // Save the updated user data
        // You should implement the save functionality here
    }




    init?(coder: NSCoder, businessListing: BusinessListing) {
        self.businessListing = businessListing
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    Add edit button and connect to editBusinessProfile View Controller

}


extension UserBusinessProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! YourTableViewCellType

        // Configure the cell with the post data
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.title
        cell.detailTextLabel?.text = post.description
        // Configure other cell properties as needed

        return cell
    }
}

extension UserBusinessProfileViewController: UITableViewDelegate {
    // Implement UITableViewDelegate methods as needed
}


func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Handle row selection here
    let selectedPost = posts[indexPath.row]
    // Perform the desired action when a row is selected
}


class BusinessUserProfile {
    var profileImage: UIImage?
    var businessName: String
    var businessAddress: String
    var profileDescription: String

    init(profileImage: UIImage?, businessName: String, businessAddress: String, profileDescription: String) {
        self.profileImage = profileImage
        self.businessName = businessName
        self.businessAddress = businessAddress
        self.profileDescription = profileDescription
    }
}

//extension UIImageView {
//    func load(url: URL) {
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}

