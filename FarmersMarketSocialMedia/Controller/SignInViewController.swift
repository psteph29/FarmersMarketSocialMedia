//
//  SignInViewController.swift
//  FarmersMarketSocialMedia
//
//  Created by Paige Stephenson on 9/14/23.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ""

       setupBackgroundImage()
    }
    
    private func setupBackgroundImage() {
        backgroundImage.image = UIImage(named: "leaves")
        backgroundImage.alpha = 0.3
        backgroundImage.contentMode = .scaleAspectFill
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func didTapSignIn(_ sender: UIButton) {
        guard let email = userName.text, !email.isEmpty,
              let password = password.text, !password.isEmpty else {
            // Alert the user that fields are empty
            showAlert(message: "Please enter both email and password.")
            return
        }

        FirebaseService.signIn(email: email, password: password) { success, uid, error in
            if success {
                // Handle successful sign in
                UserDefaults.standard.set(uid, forKey: "UserId")
                self.performSegue(withIdentifier: "SignInSuccess", sender: self)
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            } else {
                // Handle sign in error
                self.showAlert(message: error?.localizedDescription ?? "Unknown error occurred.")
            }
        }
    }
}
