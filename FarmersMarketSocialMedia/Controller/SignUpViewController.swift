//
//  SignUpViewController.swift
//  FarmersMarketSocialMedia
//
//  Created by Paige Stephenson on 9/14/23.
//

import UIKit

protocol BusinessNameDelegate: AnyObject {
    func didSelectBusinessName(_ name: String)
}

weak var businessNameDelegate: BusinessNameDelegate?


class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var businessName: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var createProfileButton: UIButton!
    
    
    @IBOutlet weak var imageUploadView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        backgroundImage.image = UIImage(named: "leaves")
        backgroundImage.alpha = 0.3
        backgroundImage.contentMode = .scaleAspectFill
    }

    @IBAction func uploadImage(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        
        alertController.popoverPresentationController?.sourceView = sender
        
        present(alertController, animated: true, completion: nil)
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as?
                UIImage else { return }
        
        imageUploadView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
//    In the SignUpViewController, you should put businessNameDelegate?.didSelectBusinessName(chosenName) at the point where the user has selected or entered their business name. This typically occurs in response to some user action like tapping a "Confirm" button or selecting a business name from a list. So, you would put it in the appropriate place within the SignUpViewController code where you have access to chosenName (the selected business name).
//    businessNameDelegate?.didSelectBusinessName(businessName)

}
