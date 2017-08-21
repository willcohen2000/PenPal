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
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var emailTextField: TextFieldPadding!
    @IBOutlet weak var passwordTextField: TextFieldPadding!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var backToHomePageLabel: UIButton!
    
    @IBOutlet weak var logoImageViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localize()
        
        logInButton.layer.cornerRadius = 15
        loadingView.isHidden = true
        gifImageView.loadGif(name: "Spinner")
        emailTextField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillAppear() {
        logoImageViewHeightConstraint.constant = 0
        
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func keyboardWillDisappear() {
        deanimateLogo()
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
        deanimateLogo()
        loadingView.isHidden = false
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
                    self.loadingView.isHidden = true
                    AuthenticationErrorService.loginErrors(error: error, controller: self)
                    MainFunctions.showErrorMessage(error: error)
                }
            }
        })
    }
    
    @IBAction func backToHomePageButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    private func deanimateLogo() {
        logoImageViewHeightConstraint.constant = 95
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    private func localize() {
        backToHomePageLabel.setTitle(NSLocalizedString("Go back to home page", comment: "Go back to home page"), for: .normal)
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


