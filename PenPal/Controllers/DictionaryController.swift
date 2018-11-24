//
//  DictionaryController.swift
//  PenPal
//
//  Created by Will Cohen on 7/26/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit
import SwiftyShadow

class DictionaryController: UIViewController {

    @IBOutlet weak var addDictionaryItemButton: UIButton!
    @IBOutlet weak var dictionaryTableView: UITableView!
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var noExitsingDictionaryEntriesLabel: UILabel!
    @IBOutlet weak var myDictionaryLabel: UILabel!
    @IBOutlet weak var addDictionaryView: UIView!
    
    var userDictionaryArray = [DictionaryEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()

        loadingImageView.loadGif(name: "StandardLoadingAnimation")
        noExitsingDictionaryEntriesLabel.isHidden = true
        dictionaryTableView.delegate = self
        dictionaryTableView.dataSource = self
        
        addDictionaryView.layer.cornerRadius = 10
        addDictionaryView.layer.shadowRadius = 5
        addDictionaryView.layer.shadowOpacity = 0.3
        addDictionaryView.layer.shadowColor = UIColor.black.cgColor
        addDictionaryView.layer.shadowOffset = CGSize.zero
        addDictionaryView.generateOuterShadow()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        FirebaseService.retrieveDictionaryEntries(userUID: User.sharedInstance.uid) { (dictionaryEntries) in
            if let dictEntries = dictionaryEntries {
                self.userDictionaryArray = dictEntries
                self.loadingImageView.isHidden = true
                if (dictEntries.count == 0) {
                    self.noExitsingDictionaryEntriesLabel.isHidden = false
                } else {
                    self.noExitsingDictionaryEntriesLabel.isHidden = true
                }
                self.dictionaryTableView.reloadData()
            } else {
                // HANDLE
            }
        }
        
    }
    
    private func localize() {
        myDictionaryLabel.text = NSLocalizedString("My Dictionary", comment: "My Dictionary")
        addDictionaryItemButton.setTitle(NSLocalizedString("Add New Entry", comment: "Add New Entry"), for: .normal)
        noExitsingDictionaryEntriesLabel.text = NSLocalizedString("No existing dictionary entries.", comment: "No existing dictionary entries")
    }

}

extension DictionaryController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDictionaryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = userDictionaryArray[indexPath.row]
        if let cell = dictionaryTableView.dequeueReusableCell(withIdentifier: "dictionaryCell") as? DictionaryCell {
            cell.configureCell(dictionary: entry)
            return cell
        } else {
            return DictionaryCell()
        }
    }
    
}
