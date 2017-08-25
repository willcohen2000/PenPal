//
//  ChatsController.swift
//  PenPal
//
//  Created by Will Cohen on 8/7/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChatsController: UIViewController {

    @IBOutlet weak var chatsListTableView: UITableView!
    @IBOutlet weak var noCurrentChatsLabel: UILabel!
    @IBOutlet weak var loadChatsImageView: UIImageView!
    
    var chats = [Chat]()
    var userChatsHandle: DatabaseHandle = 0
    var userChatsRef: DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        localize()
        loadChatsImageView.loadGif(name: "StandardLoadingAnimation")
        
        userChatsHandle = FirebaseService.observeChats { [weak self] (ref, chats) in
            self?.chats.removeAll()
            self?.userChatsRef = ref
            self?.loadChatsImageView.isHidden = true
            
            let defaults = UserDefaults.standard
            let blockedUsers = defaults.object(forKey: "blockedUsers") as? [String] ?? [String]()
    
            for (chat) in chats {
                if (!blockedUsers.contains(MainFunctions.takeObjectOutOfStringArray(object: User.sharedInstance.uid, array: chat.memberUIDs)[0])) {
                    self?.chats.append(chat)
                }
            }
            
            if (chats.count == 0) {
                self?.noCurrentChatsLabel.isHidden = false
            } else {
                self?.noCurrentChatsLabel.isHidden = true
            }
            DispatchQueue.main.async {
                self?.chatsListTableView.reloadData()
            }
        }
        
        chatsListTableView.delegate = self
        chatsListTableView.dataSource = self
        chatsListTableView.tableFooterView = UIView()
        
        noCurrentChatsLabel.isHidden = true
        
    }

    deinit {
        userChatsRef?.removeObserver(withHandle: userChatsHandle)
    }
    
    private func localize() {
        noCurrentChatsLabel.text = NSLocalizedString("No current chats.", comment: "No current chats")
    }

}

extension ChatsController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "toChat",
            let destination = segue.destination as? MessageController,
            let indexPath = chatsListTableView.indexPathForSelectedRow {
            destination.chat = chats[indexPath.row]
            destination.delegate = self
        }
    }
}

extension ChatsController: blockedUserDelegate {
    func blockedUser(_ user: String) {
        userChatsHandle = FirebaseService.observeChats { [weak self] (ref, chats) in
            self?.chats.removeAll()
            self?.userChatsRef = ref
            self?.loadChatsImageView.isHidden = true
            
            let defaults = UserDefaults.standard
            let blockedUsers = defaults.object(forKey: "blockedUsers") as? [String] ?? [String]()
            
            for (chat) in chats {
                if (!blockedUsers.contains(MainFunctions.takeObjectOutOfStringArray(object: User.sharedInstance.uid, array: chat.memberUIDs)[0])) {
                    self?.chats.append(chat)
                }
            }
            
            if (chats.count == 0) {
                self?.noCurrentChatsLabel.isHidden = false
            } else {
                self?.noCurrentChatsLabel.isHidden = true
            }
            DispatchQueue.main.async {
                self?.chatsListTableView.reloadData()
            }
        }
    }
}

extension ChatsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Segues.toChat, sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = chats[indexPath.row]
        if let cell = chatsListTableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.chatCell) as? ChatCell {
            cell.configureCell(chat: chat)
            return cell
        } else {
            return ChatCell()
        }
    }
    
}
