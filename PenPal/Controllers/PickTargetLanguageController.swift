//
//  PickTargetLanguageController.swift
//  PenPal
//
//  Created by Will Cohen on 7/14/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

class PickTargetLanguageController: UIViewController {

    @IBOutlet weak var pickTargetLanguageCollectionView: UICollectionView!
    @IBOutlet weak var pickTheLanguagesYouAreTryingToLearnLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var targetLanguages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localize()
        
        pickTargetLanguageCollectionView.delegate = self
        pickTargetLanguageCollectionView.dataSource = self
        
        pickTargetLanguageCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if (targetLanguages.count != 0) {
            User.sharedInstance.targetLanguages = []
            User.sharedInstance.targetLanguages = targetLanguages
            self.performSegue(withIdentifier: Constants.Segues.nextSegue, sender: nil)
        } else {
            MainFunctions.createSimpleAlert(alertTitle: NSLocalizedString("No Languages Selected", comment: "No Languages Selected"), alertMessage: NSLocalizedString("You need to select at least one language to continue.", comment: "You need to select at least one language to continue."), controller: self)
        }
    }
    
    private func localize() {
        pickTheLanguagesYouAreTryingToLearnLabel.text = NSLocalizedString("Pick the language(s) you are trying to learn", comment: "Choose your target language(s)")
        nextButton.setTitle(NSLocalizedString("Next", comment: "Next/Continue"), for: .normal)
    }
    
}

extension PickTargetLanguageController: pickTargetLanguageDelegate, unpickTargetLanguageDelegate {
    
    func targetLanguageSelected(_ language: String) {
        targetLanguages.append(language)
    }
    
    func targetLanguageDeselected(_ language: String) {
        if let languageIndex = targetLanguages.index(of: language) {
            targetLanguages.remove(at: languageIndex)
        }
    }
    
}

extension PickTargetLanguageController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Languages.languages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let post = Languages.languages[indexPath.row]
        if let cell = pickTargetLanguageCollectionView.dequeueReusableCell(withReuseIdentifier: "pickTargetLanguageCell", for: indexPath) as? PickLanguageCell {
            cell.configureCell(language: post)
            cell.pickDelegate = self
            cell.unpickDelegate = self
            return cell
        } else {
            return PickLanguageCell()
        }
    }
    
}



