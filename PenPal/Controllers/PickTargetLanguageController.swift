//
//  PickTargetLanguageController.swift
//  PenPal
//
//  Created by Will Cohen on 7/14/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

class PickTargetLanguageController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, pickTargetLanguageDelegate, unpickTargetLanguageDelegate {

    @IBOutlet weak var pickTargetLanguageCollectionView: UICollectionView!
    var targetLanguages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickTargetLanguageCollectionView.delegate = self
        pickTargetLanguageCollectionView.dataSource = self
        
        pickTargetLanguageCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
    }
    
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
    
    func targetLanguageSelected(_ language: String) {
        targetLanguages.append(language)
    }
    
    func targetLanguageDeselected(_ language: String) {
        if let languageIndex = targetLanguages.index(of: language) {
            targetLanguages.remove(at: languageIndex)
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if (targetLanguages.count != 0) {
            User.sharedInstance.targetLanguages = []
            User.sharedInstance.targetLanguages = targetLanguages
            self.performSegue(withIdentifier: Constants.Segues.nextSegue, sender: nil)
        } else {
            MainFunctions.createSimpleAlert(alertTitle: "No Languages Selected", alertMessage: "You need to select at least one language to continue.", controller: self)
        }
    }
    

}




