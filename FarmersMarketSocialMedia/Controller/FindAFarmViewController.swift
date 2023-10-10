//
//  SignInViewController.swift
//  FarmersMarketSocialMedia
//
//  Created by Paige Stephenson on 9/14/23.
//

import UIKit

class FindAFarmViewController: UIViewController {
    
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var findAFarmButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackgroundImage()
    }
    
    private func setupBackgroundImage() {
        backgroundImage.image = UIImage(named: "signInImage")
        backgroundImage.alpha = 0.8
        backgroundImage.contentMode = .scaleAspectFill
    }
}
