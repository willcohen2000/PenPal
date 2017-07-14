//
//  SignUpController.swift
//  PenPal
//
//  Created by Will Cohen on 7/13/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.layer.cornerRadius = 15
    }

    @IBAction func signUpButtonPressed(_ sender: Any) {
    }
    

}
