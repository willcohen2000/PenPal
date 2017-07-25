//
//  PickInterestsController.swift
//  PenPal
//
//  Created by Will Cohen on 7/24/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

class PickInterestsController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var pickInterestsCollectionView: UICollectionView!
    var selected: NSMutableSet = NSMutableSet()
    var userInterests: [Interests.InterestsEnum] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickInterestsCollectionView.delegate = self
        pickInterestsCollectionView.dataSource = self
        pickInterestsCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
    }
    
    @IBAction func backArrowButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        User.sharedInstance.interests = []
        User.sharedInstance.interests = self.userInterests
    }
}

extension PickInterestsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Interests.interests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let interest = Interests.interests[indexPath.row]
        
        if let cell = pickInterestsCollectionView.dequeueReusableCell(withReuseIdentifier: "pickInterestCell", for: indexPath) as? PickInterestsCell {
            if selected.contains(interest) {
                cell.configureCell(interest: interest, isSelectedBool: true)
            } else {
                cell.configureCell(interest: interest, isSelectedBool: false)
            }
            cell.pickDelegate = self
            cell.unpickDelegate = self
            return cell
        } else {
            return PickNativeLanguageCell()
        }
    }
}

extension PickInterestsController: pickInterestDelegate {
    func interestSelected(_ interest: Interests.InterestsEnum) {
        selected.add(interest)
        userInterests.append(interest)
    }
}

extension PickInterestsController: unpickInterestDelegate {
    func interestDeselected(_ interest: Interests.InterestsEnum) {
        selected.remove(interest)
        if let interestIndex = userInterests.index(of: interest) {
            userInterests.remove(at: interestIndex)
        }
    }
}
