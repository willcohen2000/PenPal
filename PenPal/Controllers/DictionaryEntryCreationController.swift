//
//  DictionaryEntryCreationController.swift
//  PenPal
//
//  Created by Will Cohen on 8/14/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyShadow

class DictionaryEntryCreationController: UIViewController {

    @IBOutlet weak var termTextView: UITextView!
    @IBOutlet weak var definitionTextView: UITextView!
    @IBOutlet weak var termView: UIView!
    @IBOutlet weak var definitionView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var saveToDictionaryButton: ShadowButton!
    @IBOutlet weak var loadingImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addRoundedShadow(view: definitionView)
        addRoundedShadow(view: termView)
        saveToDictionaryButton.roundedButton()
        
        loadingView.isHidden = true
        loadingImageView.loadGif(name: "StandardLoadingAnimation")
        
        termTextView.placeholder = NSLocalizedString("Remember - this dictionary works best with nouns and verbs!", comment: "Remember - this dictionary works best with nouns and verbs!")
        definitionTextView.placeholder = NSLocalizedString("We recommend that you keep your definitions short and consise. This will help you to remember it quicker.", comment: "We recommend that you keep your definitions short and consise. This will help you to remember it quicker.")
        
    }
    
    func addRoundedShadow(view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.3
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize.zero
        view.generateOuterShadow()
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
     
    @IBAction func createNewDictionaryEntryButtonPressed(_ sender: Any) {
        guard let term = termTextView.text else { return }
        guard let definition = definitionTextView.text else { return }
        
        loadingView.isHidden = false
        
        FirebaseService.uploadDictionaryEntry(userUID: User.sharedInstance.uid, entry: DictionaryEntry(term: term, definition: definition)) { (success) in
            if (success) {
                self.loadingView.isHidden = true
                self.dismiss(animated: true, completion: nil)
            } else {
                MainFunctions.createSimpleAlert(alertTitle: "Unable to submit dictionary item.", alertMessage: "It appears like you are having some network issues, and so we cannot submit your dictionary item at this time.", controller: self)
            }
        }
        
    }
    
}
