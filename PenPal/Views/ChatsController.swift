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
        
        chatsListTableView.delegate = self
        chatsListTableView.dataSource = self
        chatsListTableView.tableFooterView = UIView()
        
        noCurrentChatsLabel.isHidden = true
        
        userChatsHandle = FirebaseService.observeChats { [weak self] (ref, chats) in
            self?.userChatsRef = ref
            self?.chats = chats
            self?.loadChatsImageView.isHidden = true
            
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
