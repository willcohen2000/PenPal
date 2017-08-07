//
//  AuthenticationError+Service.swift
//  PenPal
//
//  Created by Will Cohen on 7/24/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import Foundation
import UIKit

class AuthenticationErrorService {
    
    static func loginErrors(error: Error, controller: UIViewController) {
        switch (error.localizedDescription) {
            case "The email address is badly formatted.":
                let invalidEmailAlert = UIAlertController(title: "Invalid Email", message:
                "It seems like you have put in an invalid email.", preferredStyle: UIAlertControllerStyle.alert)
                invalidEmailAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
                controller.present(invalidEmailAlert, animated: true, completion: nil)
                break;
            case "The password is invalid or the user does not have a password.":
                let wrongPasswordAlert = UIAlertController(title: "Wrong Password", message:
                "It seems like you have entered the wrong password.", preferredStyle: UIAlertControllerStyle.alert)
                wrongPasswordAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
                controller.present(wrongPasswordAlert, animated: true, completion: nil)
                break;
            case "There is no user record corresponding to this identifier. The user may have been deleted.":
                let wrongPasswordAlert = UIAlertController(title: "No Account Found", message:
                "We couldn't find an account that corresponds to that email. Do you want to create an account?", preferredStyle: UIAlertControllerStyle.alert)
                wrongPasswordAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
                wrongPasswordAlert.addAction(UIAlertAction(title: "Create Account", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                    controller.performSegue(withIdentifier: "createAccountSegue", sender: nil)
                }))
                controller.present(wrongPasswordAlert, animated: true, completion: nil)
                break;
            default:
                let loginFailedAlert = UIAlertController(title: "Error Logging In", message:
                "There was an error logging you in. Please try again soon.", preferredStyle: UIAlertControllerStyle.alert)
                loginFailedAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
                controller.present(loginFailedAlert, animated: true, completion: nil)
                break;
        }
    }
    
    static func signUpErrors(error: Error, controller: UIViewController) {
        switch(error.localizedDescription) {
            case "The email address is badly formatted.":
                let invalidEmail = UIAlertController(title: "Email is not properly formatted.", message:
                "Please enter a valid email to sign up with..", preferredStyle: UIAlertControllerStyle.alert)
                invalidEmail.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
                controller.present(invalidEmail, animated: true, completion: nil)
                break;
            default:
                let generalErrorAlert = UIAlertController(title: "We are having trouble signing you up.", message:
                "We are having trouble signing you up, please try again soon.", preferredStyle: UIAlertControllerStyle.alert)
                generalErrorAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
                controller.present(generalErrorAlert, animated: true, completion: nil)
                break;
        }
    }
    
}




