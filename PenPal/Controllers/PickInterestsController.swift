//
//  PickInterestsController.swift
//  PenPal
//
//  Created by Will Cohen on 7/24/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit
import Firebase

class PickInterestsController: UIViewController {

    @IBOutlet weak var pickInterestsCollectionView: UICollectionView!
    var selected: NSMutableSet = NSMutableSet()
    static var userInterests: [String] = []
    
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
        if (PickInterestsController.userInterests.count < 4) {
            MainFunctions.createSimpleAlert(alertTitle: "You have not selected enough interests.", alertMessage: "You must select four interests to continue.", controller: self)
        } else {
            User.sharedInstance.interests = []
            User.sharedInstance.interests = PickInterestsController.userInterests
            
            FirebaseService.saveInterestsInDatabase(uid: User.sharedInstance.uid, interests: PickInterestsController.userInterests) { (success) in
                if (success) {
                    FirebaseService.saveByLanguages(targetLanguages: User.sharedInstance.targetLanguages, nativeLanguages: User.sharedInstance.nativeLanguages)
                    FirebaseService.initiateStartingData(targetLanguages: User.sharedInstance.targetLanguages, nativeLanguages: User.sharedInstance.nativeLanguages) { (success) -> Void in
                        if (success) {
                            let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
                            let vc = homeStoryboard.instantiateViewController(withIdentifier: "tabID") as UIViewController
                            self.present(vc, animated: true, completion: nil)
                        } else {
                            MainFunctions.createSimpleAlert(alertTitle: "Unable to save your data.", alertMessage: "It seems like we are currently having issues signing you up. Please try again later.", controller: self)
                        }
                    }
                } else {
                    MainFunctions.createSimpleAlert(alertTitle: "Unable to save your data.", alertMessage: "It seems like we are currently having issues signing you up. Please try again later.", controller: self)
                }
            }
        }
    }
}

extension PickInterestsController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Interests.Interests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let interest = Interests.Interests[indexPath.row]
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
    func interestSelected(_ interest: String) {
        if (PickInterestsController.userInterests.count == 4) {
            MainFunctions.createSimpleAlert(alertTitle: "You already have four interests!", alertMessage: "It appears like you have already selected four interests. You must deselect one to add a new interest.", controller: self)
        } else {
            selected.add(interest)
            PickInterestsController.userInterests.append(interest)
        }
    }
}

extension PickInterestsController: unpickInterestDelegate {
    func interestDeselected(_ interest: String) {
        selected.remove(interest)
        if let interestIndex = PickInterestsController.userInterests.index(of: interest) {
            PickInterestsController.userInterests.remove(at: interestIndex)
        }
    }
}
