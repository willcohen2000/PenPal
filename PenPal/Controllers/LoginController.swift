//
//  LoginController.swift
//  PenPal
//
//  Created by Will Cohen on 7/13/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {

    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var emailTextField: TextFieldPadding!
    @IBOutlet weak var passwordTextField: TextFieldPadding!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButton.layer.cornerRadius = 15
    }

    @IBAction func logInButtonPressed(_ sender: Any) {
        let userEmail: String = emailTextField.text!
        let userPassword: String = passwordTextField.text!
        Auth.auth().signIn( withEmail: userEmail, password: userPassword, completion: { (user, error) in
            if error == nil {
                let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
                let vc = homeStoryboard.instantiateViewController(withIdentifier: "HomeControllerID") as UIViewController
                self.present(vc, animated: true, completion: nil)
            } else {
                MainFunctions.showErrorMessage(error: error!)
            }
        })
    }
    
    @IBAction func backToHomePageButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

