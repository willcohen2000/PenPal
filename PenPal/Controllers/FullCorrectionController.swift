//
//  FullCorrectionController.swift
//  PenPal
//
//  Created by Will Cohen on 8/9/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit
import ROGoogleTranslate

class FullCorrectionController: UIViewController {

    @IBOutlet weak var userMessageLabel: UITextView!
    @IBOutlet weak var correctionLabel: UITextView!
    @IBOutlet weak var correctionFromLabel: UILabel!
    @IBOutlet weak var translateButton: UIButton!
    
    let translator = ROGoogleTranslate()
    var correction: Correction!
    
    var didTranslate: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userMessageLabel.text = correction.originalMessage
        correctionLabel.text = correction.correction
        
        correctionLabel.isEditable = false
        userMessageLabel.isEditable = false
        translateButton.layer.cornerRadius = 5.0
        translateButton.layer.borderColor = UIColor.black.cgColor
        translateButton.layer.borderWidth = 1.0
        
        translator.apiKey = "AIzaSyBGd7mhycCRUB3kjMCghrHn5W3d6DP_rwY"
        
    }

    @IBAction func translateButtonPressed(_ sender: Any) {
        var params = ROGoogleTranslateParams()
        params.source = "de"
        params.target = Constants.languageAbbreviations[User.sharedInstance.nativeLanguages[0].lowercased()]!
        
        if let translation = correction.translation {
            self.correctionLabel.text = translation
            self.translateButton.setTitle("Translated", for: .normal)
        } else {
            if let correction = correctionLabel.text {
                params.text = correction
                translateButton.setTitle("Translating...", for: .normal)
                translator.translate(params: params) { (result) in
                    DispatchQueue.main.async {
                        FirebaseService.saveTranslation(userUID: User.sharedInstance.uid, correctionUID: self.correction.postKey, translation: result, completionHandler: { (success) in
                            if (success) {
                                self.didTranslate = true
                                self.correctionLabel.text = result
                                self.translateButton.setTitle("Translated", for: .normal)
                            } else {
                                MainFunctions.createSimpleAlert(alertTitle: "Unable to translate.", alertMessage: "We could not successfully translate this message. This may be because you don't have connection.", controller: self)
                            }
                        })
                    }
                }
            }
        }

    }
   
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
