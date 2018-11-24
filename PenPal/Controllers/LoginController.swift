//
//  LoginController.swift
//  PenPal
//
//  Created by Will Cohen on 7/13/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class LoginController: UIViewController {

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var textFieldsView: UIView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        
        logInButton.layer.cornerRadius = 8
        emailTextField.delegate = self
        textFieldsView.layer.borderColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0).cgColor;
        textFieldsView.layer.borderWidth = 1;
        textFieldsView.layer.cornerRadius = 8
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        let forgotPasswordAlert = UIAlertController(title: NSLocalizedString("Forgot your password?", comment: "Forgot your password?"), message: NSLocalizedString("Please enter the email you signed up with to change your password.", comment: "Please enter the email you signed up with to change your password."), preferredStyle: .alert)
        
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Email"
        }
        
        forgotPasswordAlert.addAction(UIAlertAction(title: NSLocalizedString("Send Email", comment: "send email"), style: .default, handler: { (_) in
            let getEmailTextField = forgotPasswordAlert.textFields![0] as UITextField
            if let emailText = getEmailTextField.text {
                Auth.auth().sendPasswordReset(withEmail: emailText) { error in
                    if (error == nil) {
                        let successAlert = UIAlertController(title: "EmailSent!", message: "", preferredStyle: .alert)
                        successAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        self.present(successAlert, animated: true, completion: nil)
                    } else {
                        if let error = error {
                            if (error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted.") {
                                let noUserAlert = UIAlertController(title: NSLocalizedString("No user found with this email", comment: "No user found with this email"), message: NSLocalizedString("We cannot find a user with this email. Please try again with a different email.", comment: "We cannot find a user with this email. Please try again with a different email."), preferredStyle: .alert)
                                noUserAlert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Okay"), style: .default, handler: nil))
                                self.present(noUserAlert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
            
        }))
        
        forgotPasswordAlert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil))
        
        self.present(forgotPasswordAlert, animated: true, completion: nil)
    }

    @IBAction func logInButtonPressed(_ sender: Any) {
        let userEmail: String = emailTextField.text!
        let userPassword: String = passwordTextField.text!
        Auth.auth().signIn( withEmail: userEmail, password: userPassword, completion: { (user, error) in
            if error == nil {
                MainFunctions.loadSingletonData(uid: (user?.uid)!, completionHandler: { (success) in
                    if (success) {
                        KeychainWrapper.standard.set((user?.uid)!, forKey: "uid")
                        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
                        let vc = homeStoryboard.instantiateViewController(withIdentifier: "tabID") as UIViewController
                        self.present(vc, animated: true, completion: nil)
                    } else {
                        
                    }
                })
            } else {
                if let error = error {
                    AuthenticationErrorService.loginErrors(error: error, controller: self)
                    MainFunctions.showErrorMessage(error: error)
                }
            }
        })
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func localize() {
        logInButton.setTitle(NSLocalizedString("Log In", comment: "Log In"), for: .normal)
        emailTextField.placeholder = NSLocalizedString("Email", comment: "Email")
        passwordTextField.placeholder = NSLocalizedString("Password", comment: "Password")
    }
    
}

extension LoginController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layoutIfNeeded()
    }

}


