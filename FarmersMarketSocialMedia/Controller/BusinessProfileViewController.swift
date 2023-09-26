//
//  BusinessProfileViewViewController.swift
//  FarmersMarketSocialMedia
//
//  Created by MJ Orton on 9/8/23.
//

import UIKit

class BusinessProfileViewController: UIViewController {
    
    @IBOutlet weak var newPost: UIButton!
    
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true

        backgroundImage.alpha = 0.3
        backgroundImage.contentMode = .scaleAspectFill
        // Do any additional setup after loading the view.
    }
    
    @IBAction func newPostButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "YourCreatePostsSegueIdentifier", sender: self)
    }

    @IBAction func editProfileButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "YourEditProfileSegueIdentifier", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreatePostsSegueIdentifier" {
            // Pass any data you need to CreatePostsViewController here
        } else if segue.identifier == "EditProfileSegueIdentifier" {
            // Pass any data you need to EditBusinessProfileViewController here
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
