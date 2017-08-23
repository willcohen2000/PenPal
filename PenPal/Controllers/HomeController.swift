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
    @IBOutlet weak var targetLanguageStaticLabel: UILabel!
    
    var dropMenuGlobal = DropDown()
    var pulledUsers = [ExternalLearner]()
    var existingChat: Chat?
    var selectedUser: PublicUser?
    var dropDownDS = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        loadingImageView.loadGif(name: "StandardLoadingAnimation")
        homeTableView.delegate = self
        homeTableView.dataSource = self
        initiateDropDownMenu()
        loadUsersTableView()
        self.noCompatibleUsersLabel.isHidden = true
        
    }
    
    private func refresh(sender: AnyObject) {
        loadUsersTableView()
    }
    
    @IBAction func dropdownMenuButtonPressed(_ sender: Any) {
        dropMenuGlobal.show()
    }
    
    private func localize() {
        targetLanguageStaticLabel.text = "\(NSLocalizedString("Target Language", comment: "Target Language")):"
        noCompatibleUsersLabel.text = NSLocalizedString("No compatible users.", comment: "No compatioble users")
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

extension HomeController: flaggedUserDelegate {
    func flaggedUser(_ user: String) {
        
        let blockOrFlagUserAlert = UIAlertController(title: NSLocalizedString("Do you want to block or flag user?", comment: "Do you want to block or flag user?"), message: "", preferredStyle: UIAlertControllerStyle.alert)
        blockOrFlagUserAlert.addAction(UIAlertAction(title: NSLocalizedString("Block User", comment: "Block User"), style: .default, handler: { (UIAlertAction) in
            let defaults = UserDefaults.standard
            var blockedUsers = defaults.object(forKey: "blockedUsers") as? [String] ?? [String]()
            blockedUsers.append(user)
            defaults.set(blockedUsers, forKey: "blockedUsers")
            defaults.synchronize()
            self.loadUsersTableView()
        }))
        
        blockOrFlagUserAlert.addAction(UIAlertAction(title: NSLocalizedString("Flag User", comment: "Flag User"), style: .default, handler: { (UIAlertAction) in
            let flagReference = Database.database().reference().child("FlaggedUsers")
            flagReference.childByAutoId().child("UID").setValue(user, withCompletionBlock: { (error, ref) in
                if (error == nil) {
                    MainFunctions.createSimpleAlert(alertTitle: "Thank you for flagging this user.", alertMessage: "Please continue to flag users who have graphic images for their profile image, as well as have an inapropriate name.", controller: self)
                }
            })
        }))
        
        blockOrFlagUserAlert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil))
        self.present(blockOrFlagUserAlert, animated: true, completion: nil)
        
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
            cell.flaggedUserDelegate = self
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
        if let targetLanguage = dropDownDS[targetLanguageLabel.text!] {
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
        
        var dropDownDataSource: [String:String] = [:]
        if let targetLanguages = User.sharedInstance.targetLanguages {
            for (language) in targetLanguages {
                dropDownDataSource[NSLocalizedString(String(describing: language), comment: "")] = String(describing: language)
            }
        }
        self.dropDownDS = dropDownDataSource
        
        var translatedLanguageArray = [String]()
        for (translatedLanguage) in dropDownDataSource {
            translatedLanguageArray.append(translatedLanguage.key)
        }
        
        dropMenuGlobal.dataSource = translatedLanguageArray
        self.targetLanguageLabel.text = translatedLanguageArray[0]
        
        dropMenuGlobal.selectionAction = { [unowned self] (index: Int, selectedLanguage: String) in
            self.targetLanguageLabel.text = selectedLanguage
            self.loadUsersTableView()
        }
    }
}
