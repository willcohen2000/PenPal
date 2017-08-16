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

    @IBOutlet weak var logoStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoStackView: UIStackView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var connecitngLanguageLearnersLabel: UILabel!
    @IBOutlet weak var logoImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoImageViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var loadingPreviouslyLoggedInUserView: UIVisualEffectView!
    @IBOutlet weak var loadingImageView: UIImageView!
    
    @IBOutlet weak var loginAndSignUpStackView: UIStackView!
    
    var didCompleteAnimation: Bool = false
    
    override func viewDidAppear(_ animated: Bool) {
        if (!didCompleteAnimation) {
            logoStackViewTopConstraint.constant = ((self.view.frame.height / 2) - (logoImageView.frame.height / 2))
            didCompleteAnimation = true
        }
        logoImageViewHeightConstraint.constant = 120
        logoImageViewWidthConstraint.constant = 282
        self.view.layoutIfNeeded()
        
        loadUpAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("superstar: \(UIScreen.main.bounds.width)")
        loadingPreviouslyLoggedInUserView.isHidden = true
        
        if (KeychainWrapper.standard.string(forKey: "uid") != nil) {
            Auth.auth().addStateDidChangeListener({ (auth, user) in
                if (user != nil) {
                    self.loadingImageView.loadGif(name: "Spinner")
                    self.loadingPreviouslyLoggedInUserView.isHidden = false
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
            })
        }
        
        loginAndSignUpStackView.alpha = 0
        connecitngLanguageLearnersLabel.textColor = UIColor.clear
        loadUpAnimation()
    }

    func loadUpAnimation() {
        logoStackViewTopConstraint.constant = 20
        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            if (success) {
                UIView.animate(withDuration: 1.0, animations: {
                    self.loginAndSignUpStackView.alpha = 1.0
                }) { (success) in
                    UIView.transition(with: self.connecitngLanguageLearnersLabel, duration: 2.0, options: .transitionCrossDissolve, animations: {
                        self.connecitngLanguageLearnersLabel.textColor = UIColor.black
                    }, completion: nil)
                }
            }
        }
    }
    
}
