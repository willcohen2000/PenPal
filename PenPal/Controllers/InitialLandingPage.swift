//
//  InitialLandingPage.swift
//  PenPal
//
//  Created by Will Cohen on 7/13/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

class InitialLandingPage: UIViewController {

    @IBOutlet weak var logoStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoStackView: UIStackView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var connecitngLanguageLearnersLabel: UILabel!
    @IBOutlet weak var logoImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoImageViewWidthConstraint: NSLayoutConstraint!
    
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
