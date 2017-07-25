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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //signUpButton.layer.cornerRadius = 15
    }

    @IBAction func signUpButtonPressed(_ sender: Any) {
        let userPassword: String = passwordTextField.text!
        let userEmail: String = emailTextField.text!
        
        if (passwordTextField.text != confirmPasswordTextField.text) {
            
        } else {
            Auth.auth().createUser(withEmail: userEmail, password: userPassword) { (user, error) in
                if let error = error {
                    AuthenticationErrorService.signUpErrors(error: error, controller: self)
                    MainFunctions.showErrorMessage(error: error) 
                    return
                }
                self.performSegue(withIdentifier: Constants.Segues.targetLanguageSegue, sender: nil)
                User.sharedInstance.uid = user?.uid
                if let userName = self.fullNameTextField.text {
                    User.sharedInstance.name = userName
                }
            }
        }
    }

    @IBAction func backToHomePageButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}





