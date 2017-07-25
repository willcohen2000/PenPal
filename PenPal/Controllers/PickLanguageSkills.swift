//
//  PickLanguageSkills.swift
//  PenPal
//
//  Created by Will Cohen on 7/24/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit
import Firebase

class PickLanguageSkills: UIViewController {

    @IBOutlet weak var oneLevelBtn: UIButton!
    @IBOutlet weak var twoLevelBtn: UIButton!
    @IBOutlet weak var threeLevelBtn: UIButton!
    @IBOutlet weak var fourLevelBtn: UIButton!
    @IBOutlet weak var fiveLevelBtn: UIButton!
    
    var skillLevelButtons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skillLevelButtons = [oneLevelBtn, twoLevelBtn, threeLevelBtn, fourLevelBtn, fiveLevelBtn]
        
    }

    @IBAction func oneLevelBtnPressed(_ sender: Any) {
        updateButtonColors(selectedButton: oneLevelBtn)
    }
    
    @IBAction func twoLevelBtnPressed(_ sender: Any) {
        updateButtonColors(selectedButton: twoLevelBtn)
    }
    
    @IBAction func threeLevelBtnPressed(_ sender: Any) {
        updateButtonColors(selectedButton: threeLevelBtn)
    }

    @IBAction func fourLevelBtnPressed(_ sender: Any) {
        updateButtonColors(selectedButton: fourLevelBtn)
    }
   
    @IBAction func fiveLevelBtnPressed(_ sender: Any) {
        updateButtonColors(selectedButton: fiveLevelBtn)
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        
        FirebaseService.initiateStartingData(targetLanguages: User.sharedInstance.targetLanguages, nativeLanguages: User.sharedInstance.nativeLanguages, userInterests: User.sharedInstance.interests) { (success) -> Void in
            if (success) {
                let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
                let vc = homeStoryboard.instantiateViewController(withIdentifier: "HomeControllerID") as UIViewController
                self.present(vc, animated: true, completion: nil)
            } else {
                //handle error
            }
        }
    }
    
}

extension PickLanguageSkills {
    func updateButtonColors(selectedButton: UIButton) {
        for (skillButton) in skillLevelButtons {
            if (selectedButton == skillButton) {
                skillButton.backgroundColor = Colors.pickLevelSelected
                User.sharedInstance.skillLevelInt = Int(skillButton.titleLabel!.text!)!
            } else {
                skillButton.backgroundColor = Colors.pickLevelNotSelected
            }
        }
    }
}


