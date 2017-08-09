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
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var emailTextField: TextFieldPadding!
    @IBOutlet weak var passwordTextField: TextFieldPadding!
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoImageViewHeightConstraint: NSLayoutConstraint!
    
    var emailText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    private func deanimateLogo() {
        logoImageViewHeightConstraint.constant = 95
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
        })
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
                        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
                        let vc = homeStoryboard.instantiateViewController(withIdentifier: "tabID") as UIViewController
                        self.present(vc, animated: true, completion: nil)
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

}

extension LoginController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layoutIfNeeded()
    }

}


