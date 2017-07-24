//
//  PickInterestsController.swift
//  PenPal
//
//  Created by Will Cohen on 7/24/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

class PickInterestsController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, pickInterestDelegate, unpickInterestDelegate {
    
    func interestSelected(_ interest: Interests.InterestsEnum) {
        print(111)
    }
    
    func interestDeselected(_ interest: Interests.InterestsEnum) {
        print(222)
    }

    @IBOutlet weak var pickInterestsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickInterestsCollectionView.delegate = self
        pickInterestsCollectionView.dataSource = self
        pickInterestsCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Interests.interests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let interest = Interests.interests[indexPath.row]
        if let cell = pickInterestsCollectionView.dequeueReusableCell(withReuseIdentifier: "pickInterestCell", for: indexPath) as? PickInterestsCell {
            cell.configureCell(interest: interest)
            cell.pickDelegate = self
            cell.unpickDelegate = self
            return cell
        } else {
            return PickNativeLanguageCell()
        }
    }
   
    @IBAction func backArrowButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        
    }
    
}
