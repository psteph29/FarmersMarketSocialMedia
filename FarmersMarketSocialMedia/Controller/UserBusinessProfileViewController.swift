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
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var postsTableView: UITableView!
    
    var farm: Farm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessNameLabel.text = farm.listingName
        businessAddressLabel.text = farm.locationAddress

        if let description = farm.briefDescription, !description.isEmpty {
            descriptionTextView.text = description
        } else {
            descriptionTextView.text = "The farm has not listed a description"
        }

        descriptionTextView.text = farm.briefDescription
        contactInformation.text = farm.contactPhone
        email.text = farm.mediaWebsite
        
    
        backgroundImage.alpha = 0.3
        backgroundImage.contentMode = .scaleAspectFill

    }
    
    init?(coder: NSCoder, farm: Farm) {
        self.farm = farm
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
