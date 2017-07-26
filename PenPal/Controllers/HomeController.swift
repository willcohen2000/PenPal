//
//  HomeController.swift
//  PenPal
//
//  Created by Will Cohen on 7/13/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit
import DropDown
import Firebase

class HomeController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var dropdownMenu: UIButton!
    @IBOutlet weak var targetLanguageLabel: UILabel!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var dropDownMenuHoldingView: UIView!
    
    var dropMenuGlobal = DropDown()
    var pulledUsers = [ExternalLearner]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        initiateDropDownMenu()
        loadUsersTableView()
        
    }
    
    @IBAction func dropdownMenuButtonPressed(_ sender: Any) {
        dropMenuGlobal.show()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pulledUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = pulledUsers[indexPath.row]
        if let cell = homeTableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.homeCell) as? ExternalLearnerCell {
            cell.configureCell(person: person)
            return cell
        } else {
            return ExternalLearnerCell()
        }
    }


}

extension HomeController {
    func loadUsersTableView() {
        self.pulledUsers.removeAll()
        if let targetLanguage = targetLanguageLabel.text {
            FirebaseService.findCompatibleUsers(targetLanguage: targetLanguage, nativeLanguages: User.sharedInstance.nativeLanguages, completionHandler: { (users) in
                for (uid) in users {
                    let usersReference = Database.database().reference().child("Users")
                    usersReference.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        let name = value?["fullName"] as? String ?? ""
                        let interests = value?["Interests"] as? [String:String] ?? [:]
                        let imageUrl = value?["profileImageUrl"] as? String ?? ""
                        let postKey = uid
                        self.pulledUsers.append(ExternalLearner(name: name, interests: interests, imageURL: imageUrl, postKey: postKey))
                        self.homeTableView.reloadData()
                    })
                }
            })
        }
    }
    
    func initiateDropDownMenu() {
        dropMenuGlobal.anchorView = dropDownMenuHoldingView
        dropDownMenuHoldingView.isHidden = true
        
        var dropDownDataSource: [String] = []
        for (interest) in User.sharedInstance.targetLanguages {
            dropDownDataSource.append(String(describing: interest))
        }
        dropMenuGlobal.dataSource = dropDownDataSource
        self.targetLanguageLabel.text = dropDownDataSource[0]
        dropMenuGlobal.selectionAction = { [unowned self] (index: Int, selectedLanguage: String) in
            self.targetLanguageLabel.text = selectedLanguage
            self.loadUsersTableView()
        }
    }
}
