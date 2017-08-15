//
//  DictionaryController.swift
//  PenPal
//
//  Created by Will Cohen on 7/26/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

class DictionaryController: UIViewController {

    @IBOutlet weak var addDictionaryItemButton: UIButton!
    @IBOutlet weak var dictionaryTableView: UITableView!
    
    var userDictionaryArray = [DictionaryEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeAddDictionaryButton()
        dictionaryTableView.delegate = self
        dictionaryTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        FirebaseService.retrieveDictionaryEntries(userUID: User.sharedInstance.uid) { (dictionaryEntries) in
            if let dictEntries = dictionaryEntries {
                self.userDictionaryArray = dictEntries
                self.dictionaryTableView.reloadData()
            } else {
                // HANDLE
            }
        }
    }
    
    private func customizeAddDictionaryButton() {
        addDictionaryItemButton.layer.cornerRadius = addDictionaryItemButton.frame.height / 2
        addDictionaryItemButton.layer.borderColor = UIColor.black.cgColor
        addDictionaryItemButton.layer.borderWidth = 0.5
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
