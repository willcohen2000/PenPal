//
//  InitialLandingPage.swift
//  PenPal
//
//  Created by Will Cohen on 7/13/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class InitialLandingPage: UIViewController {

    @IBOutlet weak var logoStackView: UIStackView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var connecitngLanguageLearnersLabel: UILabel!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loadingPreviouslyLoggedInUserView: UIVisualEffectView!
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var loginAndSignUpStackView: UIStackView!
    
    var didCompleteAnimation: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        localize()
        
        loadingPreviouslyLoggedInUserView.isHidden = true
        
        logInButton.layer.cornerRadius = (logInButton.frame.height / 2)
        signUpButton.layer.cornerRadius = (signUpButton.frame.height / 2)
        logInButton.setTitle(logInButton.titleLabel?.text?.uppercased(), for: UIControlState.normal)
        signUpButton.setTitle(signUpButton.titleLabel?.text?.uppercased(), for: UIControlState.normal)
        
        if (KeychainWrapper.standard.string(forKey: "uid") != nil) {
            Auth.auth().addStateDidChangeListener({ (auth, user) in
                if (user != nil) {
                    self.loadingImageView.loadGif(name: "Spinner")
                    self.loadingPreviouslyLoggedInUserView.isHidden = false
                    if (KeychainWrapper.standard.bool(forKey: "setUserInformation") == false) {
                        MainFunctions.loadCriticalUserInfo(userUID: (user?.uid)!, completionHandler: { (success) in
                            if (success) {
                                User.sharedInstance.uid = (user?.uid)!
                                self.performSegue(withIdentifier: "toSignUp", sender: nil)
                            }
                        })
                    } else {
                        MainFunctions.loadSingletonData(uid: (user?.uid)!, completionHandler: { (success) in
                            if (success) {
                                KeychainWrapper.standard.set((user?.uid)!, forKey: "uid")
                                let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
                                let vc = homeStoryboard.instantiateViewController(withIdentifier: "tabID") as UIViewController
                                self.present(vc, animated: true, completion: nil)
                            } else {
                                // HANDLE
                            }
                        })
                    }
                }
            })
        }
 
    }
    
    private func localize() {
        connecitngLanguageLearnersLabel.text = NSLocalizedString("Connecting language learners worldwide", comment: "")
        logInButton.setTitle(NSLocalizedString("Log In", comment: "Log In"), for: .normal)
        signUpButton.setTitle(NSLocalizedString("Sign Up", comment: "Register/Sign Up"), for: .normal)
    }

    
}
