//
//  SignInViewController.swift
//  FarmersMarketSocialMedia
//
//  Created by Paige Stephenson on 9/14/23.
//

import UIKit

class SignInViewController: UIViewController {
    

    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImage.image = UIImage(named: "leaves")
        backgroundImage.alpha = 0.3
        backgroundImage.contentMode = .scaleAspectFill
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
