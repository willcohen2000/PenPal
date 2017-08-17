//
//  DictionaryEntryCreationController.swift
//  PenPal
//
//  Created by Will Cohen on 8/14/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DictionaryEntryCreationController: UIViewController {

    @IBOutlet weak var termTextView: UITextView!
    @IBOutlet weak var definitionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        termTextView.placeholder = NSLocalizedString("Remember - this dictionary works best with nouns and verbs!", comment: "Remember - this dictionary works best with nouns and verbs!")
        definitionTextView.placeholder = NSLocalizedString("We recommend that you keep your definitions short and consise. This will help you to remember it quicker.", comment: "We recommend that you keep your definitions short and consise. This will help you to remember it quicker.")
        
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
     
    @IBAction func createNewDictionaryEntryButtonPressed(_ sender: Any) {
        guard let term = termTextView.text else { return }
        guard let definition = definitionTextView.text else { return }
        
        FirebaseService.uploadDictionaryEntry(userUID: User.sharedInstance.uid, entry: DictionaryEntry(term: term, definition: definition)) { (success) in
            if (success) {
                self.dismiss(animated: true, completion: nil)
            } else {
                // HANDLE
            }
        }
        
    }
    
}
