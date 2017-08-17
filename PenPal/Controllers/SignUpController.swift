//
//  SignUpController.swift
//  PenPal
//
//  Created by Will Cohen on 7/13/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SignUpController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailTextField: TextFieldPadding!
    @IBOutlet weak var passwordTextField: TextFieldPadding!
    @IBOutlet weak var confirmPasswordTextField: TextFieldPadding!
    @IBOutlet weak var fullNameTextField: TextFieldPadding!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var gifLoadingImage: UIImageView!
    @IBOutlet weak var backToHomePageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        signUpButton.layer.cornerRadius = 15
        loadingView.isHidden = true
        gifLoadingImage.loadGif(name: "Spinner")
    }

    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        guard let userPassword: String = passwordTextField.text else { return }
        guard let userEmail: String = emailTextField.text else { return }
        guard let fullName: String = fullNameTextField.text else { return }
        
        if (passwordTextField.text != confirmPasswordTextField.text) {
            MainFunctions.textFieldError(textFields: [passwordTextField, confirmPasswordTextField])
            let passwordsDontMatchAlert = UIAlertController(title: NSLocalizedString("Passwords Do Not Match", comment: "Passwords Do Not Match"), message:
                NSLocalizedString("It seems like you have entered in two different passwords.", comment: "It seems like you have entered in two different passwords."), preferredStyle: UIAlertControllerStyle.alert)
            passwordsDontMatchAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            self.present(passwordsDontMatchAlert, animated: true, completion: nil)
        } else if userPassword.characters.count < 6 {
            MainFunctions.createSimpleAlert(alertTitle: NSLocalizedString("Password too short.", comment: "Password too short."), alertMessage: NSLocalizedString("Passwords must contain at least six characters.", comment: "Passwords must contain at least six characters."), controller: self)
        } else {
            self.loadingView.isHidden = false
            Auth.auth().createUser(withEmail: userEmail, password: userPassword) { (user, error) in
                if let error = error {
                    self.loadingView.isHidden = true
                    AuthenticationErrorService.signUpErrors(error: error, controller: self)
                    MainFunctions.showErrorMessage(error: error) 
                    return
                }
                FirebaseService.storeUserInDatabase(uid: (user?.uid)!, name: fullName, profileImageUrl: "", completionHandler: { (success) in
                    if (success) {
                        KeychainWrapper.standard.set((user?.uid)!, forKey: "uid")
                        self.performSegue(withIdentifier: Constants.Segues.targetLanguageSegue, sender: nil)
                        User.sharedInstance.uid = user?.uid
                        if let userName = self.fullNameTextField.text {
                            User.sharedInstance.name = userName
                        }
                    } else {
                        self.loadingView.isHidden = true
                        MainFunctions.createSimpleAlert(alertTitle: NSLocalizedString("Error signing up", comment: "Error signing up"), alertMessage: NSLocalizedString("It seems like there was an error signing you up. Please try again soon.", comment: "It seems like there was an error signing you up. Please try again soon."), controller: self)
                    }
                })
            }
        }
        
    }
    
    private func localize() {
        signUpButton.setTitle(NSLocalizedString("Sign Up", comment: "Sign Up/Register"), for: .normal)
        emailTextField.placeholder = NSLocalizedString("Email", comment: "Email")
        passwordTextField.placeholder = NSLocalizedString("Password", comment: "Password")
        confirmPasswordTextField.placeholder = NSLocalizedString("Confirm Password", comment: "Confirm Password")
        fullNameTextField.placeholder = NSLocalizedString("Full Name", comment: "First and last name")
        backToHomePageButton.setTitle(NSLocalizedString("Go back to home page", comment: "Go back to home page"), for: .normal)
    }
    
    @IBAction func backToHomePageButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}


