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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var backToHomePageButton: UIButton!
    @IBOutlet weak var textFieldsHolder: UIView!
    @IBOutlet weak var errorMessageHolder: UIView!
    @IBOutlet weak var errorMessageTextView: UITextView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        signUpButton.layer.cornerRadius = 15
        textFieldsHolder.layer.borderColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0).cgColor;
        textFieldsHolder.layer.borderWidth = 1;
        textFieldsHolder.layer.cornerRadius = 8
        errorMessageHolder.layer.cornerRadius = 5
        
        errorMessageHolder.isHidden = true;
        errorMessageTextView.isHidden = true;
    }

    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        guard let userPassword: String = passwordTextField.text else { return }
        guard let userEmail: String = emailTextField.text else { return }
        guard let fullName: String = fullNameTextField.text else { return }
        
        if (passwordTextField.text != confirmPasswordTextField.text) {
            errorMessageHolder.isHidden = false;
            errorMessageTextView.isHidden = false;
            errorMessageTextView.text = NSLocalizedString("Passwords Do Not Match", comment: "Passwords Do Not Match");
        } else if userPassword.characters.count < 6 {
            errorMessageHolder.isHidden = false;
            errorMessageTextView.isHidden = false;
            errorMessageTextView.text = NSLocalizedString("Password too short.", comment: "Password too short.")
        } else {
            Auth.auth().createUser(withEmail: userEmail, password: userPassword) { (user, error) in
                if let error = error {
                    AuthenticationErrorService.signUpErrors(error: error, controller: self)
                    MainFunctions.showErrorMessage(error: error) 
                    return
                }
                FirebaseService.storeUserInDatabase(uid: (user?.uid)!, name: fullName, profileImageUrl: "", completionHandler: { (success) in
                    if (success) {
                        KeychainWrapper.standard.set((user?.uid)!, forKey: "uid")
                        KeychainWrapper.standard.set(false, forKey: "setUserInformation")
                        self.performSegue(withIdentifier: Constants.Segues.targetLanguageSegue, sender: nil)
                        User.sharedInstance.uid = user?.uid
                        if let userName = self.fullNameTextField.text {
                            User.sharedInstance.name = userName
                        }
                    } else {
                        self.errorMessageHolder.isHidden = false;
                        self.errorMessageTextView.isHidden = false;
                        self.errorMessageTextView.text = NSLocalizedString("Error signing up", comment: "Error signing up")
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


