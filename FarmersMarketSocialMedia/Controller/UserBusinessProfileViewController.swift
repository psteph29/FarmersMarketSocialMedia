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
    @IBOutlet weak var contactInformation: UILabel!
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!

    
    @IBOutlet weak var postsTableView: UITableView!
    
    var businessListing: BusinessListing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
