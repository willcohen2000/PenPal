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
    
    var targetLanguages: [String] = []
    var selectedLanguages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    MainFunctions.createSimpleAlert(alertTitle: "Could not save your target language.", alertMessage: "It appears like we can not correctly save your new language. Please try again later.", controller: self)
                }
            })
        } else {
            MainFunctions.createSimpleAlert(alertTitle: "No Languages Selected", alertMessage: "You need to select at least one language to continue.", controller: self)
        }
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
        print("hello \(targetLanguages.count)")
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



