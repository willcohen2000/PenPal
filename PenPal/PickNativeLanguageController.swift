//
//  PickNativeLanguageController.swift
//  PenPal
//
//  Created by Will Cohen on 7/17/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

class PickNativeLanguageController: UIViewController {

    @IBOutlet weak var pickNativeLanguageCollectionView: UICollectionView!
    @IBOutlet weak var pickLanguageYouAreAlreadyFluentInLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var nativeLanguages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localize()
        
        pickNativeLanguageCollectionView.delegate = self
        pickNativeLanguageCollectionView.dataSource = self
        
        pickNativeLanguageCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        
    }

    @IBAction func nextButtonPressed(_ sender: Any) {
        if (nativeLanguages.count != 0) {
            User.sharedInstance.nativeLanguages = []
            User.sharedInstance.nativeLanguages = nativeLanguages
            self.performSegue(withIdentifier: Constants.Segues.nextSegue, sender: nil)
        } else {
            MainFunctions.createSimpleAlert(alertTitle: NSLocalizedString("No Languages Selected", comment: "No Languages Selected"), alertMessage: NSLocalizedString("You need to select at least one language to continue.", comment: "You need to select at least one language to continue."), controller: self)
        }
    }
    
    @IBAction func backArrowButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func localize() {
        pickLanguageYouAreAlreadyFluentInLabel.text = NSLocalizedString("Pick the language(s) you are already fluent in", comment: "Choose your target language(s)")
        nextButton.setTitle(NSLocalizedString("Next", comment: "Next/Continue"), for: .normal)
    }
    
}

extension PickNativeLanguageController: pickNativeLanguageDelegate, unpickNativeLanguageDelegate {
    
    func nativeLanguageSelected(_ language: String) {
        nativeLanguages.append(language)
    }
    
    func nativeLanguageDeselected(_ language: String) {
        if let languageIndex = nativeLanguages.index(of: language) {
            nativeLanguages.remove(at: languageIndex)
        }
    }
    
}

extension PickNativeLanguageController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Languages.languages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let post = Languages.languages[indexPath.row]
        if let cell = pickNativeLanguageCollectionView.dequeueReusableCell(withReuseIdentifier: "pickNativeLanguageCell", for: indexPath) as? PickNativeLanguageCell {
            cell.pickDelegate = self
            cell.unpickDelegate = self
            cell.configureCell(language: post)
            return cell
        } else {
            return PickNativeLanguageCell()
        }
    }
    
}
