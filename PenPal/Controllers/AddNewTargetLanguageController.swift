//
//  AddNewTargetLanguageController.swift
//  PenPal
//
//  Created by Will Cohen on 8/10/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

class AddNewTargetLanguageController: UIViewController {
    
    @IBOutlet weak var pickNewTargetLanguageCollectionView: UICollectionView!
    @IBOutlet weak var languagesYouAreFluentInLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var targetLanguages: [String] = []
    var selectedLanguages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localize()
        pickNewTargetLanguageCollectionView.delegate = self
        pickNewTargetLanguageCollectionView.dataSource = self
        pickNewTargetLanguageCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if (targetLanguages.count != 0) {
            
            FirebaseService.saveUserTargetLanguages(userUID: User.sharedInstance.uid, targetLanguages: selectedLanguages, completionHandler: { (success) in
                if (success) {
                    for (language) in self.selectedLanguages {
                        User.sharedInstance.targetLanguages.append(language)
                    }
                    self.dismiss(animated: true, completion: nil)
                } else {
                    MainFunctions.createSimpleAlert(alertTitle: NSLocalizedString("Could not save your target language.", comment: "Could not save your target language."), alertMessage: NSLocalizedString("It appears like we can not correctly save your new language. Please try again later.", comment: "It appears like we can not correctly save your new language. Please try again later."), controller: self)
                }
            })
        } else {
            MainFunctions.createSimpleAlert(alertTitle: NSLocalizedString("No Languages Selected", comment: "No Languages Selected"), alertMessage: NSLocalizedString("You need to select at least one language to continue.", comment: "You need to select at least one language to continue."), controller: self)
        }
    }
    
    private func localize() {
        nextButton.setTitle(NSLocalizedString("Done", comment: "Done"), for: .normal)
        languagesYouAreFluentInLabel.text = NSLocalizedString("What language do you want to add?", comment: "What language do you want to add?")
    }
    
}

extension AddNewTargetLanguageController: pickNewTargetLanguageDelegate, unpickNewTargetLanguageDelegate {
    
    func targetLanguageSelected(_ language: String) {
        selectedLanguages.append(language)
    }
    
    func targetLanguageDeselected(_ language: String) {
        if let languageIndex = selectedLanguages.index(of: language) {
            selectedLanguages.remove(at: languageIndex)
        }
    }
    
}

extension AddNewTargetLanguageController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return targetLanguages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let post = targetLanguages[indexPath.row]
        if let cell = pickNewTargetLanguageCollectionView.dequeueReusableCell(withReuseIdentifier: "pickNewTargetLanguageCell", for: indexPath) as? AddNewTargetLanguageCell {
            cell.configureCell(language: post)
            cell.pickDelegate = self
            cell.unpickDelegate = self
            return cell
        } else {
            return AddNewTargetLanguageCell()
        }
    }
    
}



