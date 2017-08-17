//
//  EditInterestsController.swift
//  PenPal
//
//  Created by Will Cohen on 8/14/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

class EditInterestsController: UIViewController {
    
    @IBOutlet weak var editInterestCollectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pickFourInterestLabel: UILabel!
    
    var selected: NSMutableSet = NSMutableSet()
    static var userInterests: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localize()
        
        editInterestCollectionView.delegate = self
        editInterestCollectionView.dataSource = self
        editInterestCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        
        FirebaseService.getUserIntrerests(userUID: User.sharedInstance.uid) { (interests) in
            if (interests.count != 0) {
                self.selected.addObjects(from: interests)
                EditInterestsController.userInterests = interests
                self.editInterestCollectionView.reloadData()
            } else {
                // HANDLE
            }
        }
        
    }
    
    @IBAction func backArrowButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishedEditingButtonPressed(_ sender: Any) {
        if (EditInterestsController.userInterests.count < 4) {
            MainFunctions.createSimpleAlert(alertTitle: NSLocalizedString("You have not selected enough interests.", comment: "You have not selected enough interests."), alertMessage: NSLocalizedString("You must select four interests to continue.", comment: "You must select four interests to continue."), controller: self)
        } else {
            
            User.sharedInstance.interests = []
            User.sharedInstance.interests = EditInterestsController.userInterests
            
            FirebaseService.saveUserInterests(userUID: User.sharedInstance.uid, interests: EditInterestsController.userInterests, completionHandler: { (success) in
                if (success) {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    // HANDLE
                }
            })
            
        }
    }
    
    private func localize() {
        doneButton.setTitle(NSLocalizedString("Done", comment: "Done"), for: .normal)
        pickFourInterestLabel.text = NSLocalizedString("Edit my four things to talk about", comment: "Edit my four things to talk about")
    }
    
}

extension EditInterestsController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Interests.Interests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let interest = Interests.Interests[indexPath.row]
        if let cell = editInterestCollectionView.dequeueReusableCell(withReuseIdentifier: "editInterestCell", for: indexPath) as? EditInterestCell {
            if selected.contains(interest) {
                cell.configureCell(interest: interest, isSelectedBool: true)
            } else {
                cell.configureCell(interest: interest, isSelectedBool: false)
            }
            cell.pickDelegate = self
            cell.unpickDelegate = self
            return cell
        } else {
            return EditInterestCell()
        }
    }
}

extension EditInterestsController: editInterestPickDelegate {
    func interestSelected(_ interest: String) {
        if (EditInterestsController.userInterests.count == 4) {
            MainFunctions.createSimpleAlert(alertTitle: NSLocalizedString("You already have four interests!", comment: "You already have four interests!"), alertMessage: NSLocalizedString("It appears like you have already selected four interests. You must deselect one to add a new interest.", comment: "It appears like you have already selected four interests. You must deselect one to add a new interest."), controller: self)
        } else {
            selected.add(interest)
            EditInterestsController.userInterests.append(interest)
        }
    }
}

extension EditInterestsController: editInterestUnpickDelegate {
    func interestDeselected(_ interest: String) {
        selected.remove(interest)
        if let interestIndex = EditInterestsController.userInterests.index(of: interest) {
            EditInterestsController.userInterests.remove(at: interestIndex)
        }
    }
}
