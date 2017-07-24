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
    
    func targetLanguageSelected(_ language: Languages.LanguagesEnum) {
        print("1")
    }
    
    func targetLanguageDeselected(_ language: Languages.LanguagesEnum) {
        print("2")
    }
    
    @IBAction func backArrowButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}




