//
//  SettingsController.swift
//  PenPal
//
//  Created by Will Cohen on 7/26/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {

    @IBOutlet weak var editMyFourThingsButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePictureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadSettingsView()
        
    }

    @IBAction func editMyFourThingsButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func profilePictureButtonPressed(_ sender: Any) {
    }

}

extension SettingsController {
    func loadSettingsView() {
        editMyFourThingsButton.layer.borderColor = UIColor.black.cgColor
        editMyFourThingsButton.layer.cornerRadius = editMyFourThingsButton.frame.height / 2
        editMyFourThingsButton.layer.borderWidth = 1.0
        nameLabel.text = User.sharedInstance.name
    }
}
