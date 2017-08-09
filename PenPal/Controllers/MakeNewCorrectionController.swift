//
//  MakeNewCorrectionController.swift
//  PenPal
//
//  Created by Will Cohen on 8/8/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class MakeNewCorrectionController: UIViewController {

    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var correctionTextView: UITextView!
    
    @IBOutlet weak var messageTextViewTopConstraint: NSLayoutConstraint!
    
    var message: String = ""
    var members: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextView.text = message
        correctionTextView.placeholder = "Type your corrections in here, preferably in your native language."
        correctionTextView.placeholderColor = UIColor.lightGray
        
        loadKeyboardObservers()
        
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendCorrectionButtonPressed(_ sender: Any) {
        if (correctionTextView.text != "" && correctionTextView.text != correctionTextView.placeholder) {
            FirebaseService.postCorrection(forUserUID: members[0], fromUserName: User.sharedInstance.name, originalMessage: message, correction: correctionTextView.text!, profileImageURL: User.sharedInstance.imageUrl, completionHandler: { (success) in
                if (success) {
                    let alert = UIAlertController(title: "Thank you for correcting this message!", message:
                        "We appreciate your contribution, and hope that you continue to correct other mistakes you may encounter.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    // HANDLE ERROR
                }
            })
        } else {
            // HANDLE
        }
    }
    
    
}

extension MakeNewCorrectionController {
    
     func loadKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillAppear() {
        print("YES")
    }
    
    @objc func keyboardWillDisappear() {
        print("PERHAPS")
    }
    
}


