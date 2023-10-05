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
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImage.alpha = 0.3
        backgroundImage.contentMode = .scaleAspectFill
        // Do any additional setup after loading the view.
    }
    

}
