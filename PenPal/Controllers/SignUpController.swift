//
//  SignUpController.swift
//  PenPal
//
//  Created by Will Cohen on 7/13/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var emailTextField: TextFieldPadding!
    @IBOutlet weak var passwordTextField: TextFieldPadding!
    @IBOutlet weak var confirmPasswordTextField: TextFieldPadding!
    @IBOutlet weak var fullNameTextField: TextFieldPadding!
    
    @IBOutlet weak var setProfileImageButton: UIButton!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func signUpButtonPressed(_ sender: Any) {
        guard let userPassword: String = passwordTextField.text else {return}
        guard let userEmail: String = emailTextField.text else {return}
        guard let fullName: String = fullNameTextField.text else {return}
        
        if (passwordTextField.text != confirmPasswordTextField.text) {
            MainFunctions.textFieldError(textFields: [passwordTextField, confirmPasswordTextField])
            let passwordsDontMatchAlert = UIAlertController(title: "Passwords Do Not Match", message:
                "It seems like you have entered in two different passwords.", preferredStyle: UIAlertControllerStyle.alert)
            passwordsDontMatchAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            self.present(passwordsDontMatchAlert, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: userEmail, password: userPassword) { (user, error) in
                if let error = error {
                    AuthenticationErrorService.signUpErrors(error: error, controller: self)
                    MainFunctions.showErrorMessage(error: error) 
                    return
                }
                FirebaseService.storeUserInDatabase(uid: (user?.uid)!, name: fullName, profileImageUrl: "", completionHandler: { (success) in
                    if (success) {
                        self.performSegue(withIdentifier: Constants.Segues.targetLanguageSegue, sender: nil)
                        User.sharedInstance.uid = user?.uid
                        if let userName = self.fullNameTextField.text {
                            User.sharedInstance.name = userName
                        }
                    } else {
                        // HANDLE ERROR
                    }
                })
            }
        }
    }
    
    @IBAction func backToHomePageButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

/*extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let profileImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            setProfileImageButton.maskCircle(anyImage: profileImage)
            selectedImage = profileImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    let storageReference = Storage.storage().reference().child("ProfileImages").child((user?.uid)!)
    if let profileImage = self.selectedImage {
        let imageData = UIImageJPEGRepresentation(profileImage, 0.1)
        storageReference.putData(imageData!, metadata: nil, completion: { (metaData, error) in
            if (error != nil) {
                // HANDLE ERROR
                return
            } else {
                
            }
        })
    }
 
 
 
 let pickerController =  UIImagePickerController()
 pickerController.delegate = self
 self.present(pickerController, animated: true, completion: nil)
 
}*/


