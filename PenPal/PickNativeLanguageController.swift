//
//  PickNativeLanguageController.swift
//  PenPal
//
//  Created by Will Cohen on 7/17/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

class PickNativeLanguageController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,pickNativeLanguageDelegate, unpickNativeLanguageDelegate {

    @IBOutlet weak var pickNativeLanguageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickNativeLanguageCollectionView.delegate = self
        pickNativeLanguageCollectionView.dataSource = self
        
        pickNativeLanguageCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
    }
    
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
    
    func nativeLanguageSelected(_ language: Languages.LanguagesEnum) {
        print("hellosd")
    }
    
    func nativeLanguageDeselected(_ language: Languages.LanguagesEnum) {
        print("kafdjh")
    }

    @IBAction func backArrowButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


