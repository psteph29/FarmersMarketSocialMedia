//
//  SignInViewController.swift
//  FarmersMarketSocialMedia
//
//  Created by Paige Stephenson on 9/14/23.
//

import UIKit

class SignInViewController: UIViewController {
    
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImage.image = UIImage(named: "signInImage")
        backgroundImage.alpha = 0.3
        backgroundImage.contentMode = .scaleAspectFill
    }
    

}
