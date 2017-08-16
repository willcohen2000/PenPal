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

class HomeController: UIViewController {
    
    @IBOutlet weak var dropdownMenu: UIButton!
    @IBOutlet weak var targetLanguageLabel: UILabel!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var dropDownMenuHoldingView: UIView!
    
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var noCompatibleUsersLabel: UILabel!
    
    var dropMenuGlobal = DropDown()
    var pulledUsers = [ExternalLearner]()
    var existingChat: Chat?
    var selectedUser: PublicUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingImageView.loadGif(name: "StandardLoadingAnimation")
        homeTableView.delegate = self
        homeTableView.dataSource = self
        initiateDropDownMenu()
        loadUsersTableView()
        self.noCompatibleUsersLabel.isHidden = true
        
    }
    
    func refresh(sender: AnyObject) {
        loadUsersTableView()
    }
    
    @IBAction func dropdownMenuButtonPressed(_ sender: Any) {
        dropMenuGlobal.show()
    }
    
}

extension HomeController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.toChat {
            if segue.destination is MessageController {
                let destination = segue.destination as? MessageController
                let members = [selectedUser, PublicUser(name: User.sharedInstance.name, uid: User.sharedInstance.uid)]
                destination?.chat = existingChat ?? Chat(members: members as! [PublicUser])
            }
        }
    }
}

extension HomeController: clickedTalkToUser {
    func clickedTalkToUser(_ person: ExternalLearner) {
        ChatService.checkForExistingChat(with: PublicUser(name: person.name, uid: person.postKey)) { (chat) in
            self.existingChat = chat
            self.selectedUser = PublicUser(name: person.name, uid: person.postKey)
            self.performSegue(withIdentifier: Constants.Segues.toChat, sender: self)
        }
    }
}

extension HomeController: UITableViewDataSource, UITableViewDelegate {
    
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
            cell.clickedTalkToUserDelegate = self
            return cell
        } else {
            return ExternalLearnerCell()
        }
    }
    
}

extension HomeController {
    func loadUsersTableView() {
        self.pulledUsers.removeAll()
        self.homeTableView.reloadData()
        if let targetLanguage = targetLanguageLabel.text {
            FirebaseService.findCompatibleUsers(targetLanguage: targetLanguage, nativeLanguages: User.sharedInstance.nativeLanguages, completionHandler: { (users) in
                self.loadingImageView.isHidden = true
                if (users.count != 0) {
                    self.noCompatibleUsersLabel.isHidden = true
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
                } else {
                    self.noCompatibleUsersLabel.isHidden = false
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
