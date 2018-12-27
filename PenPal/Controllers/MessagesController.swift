//
//  MessagesController.swift
//  PenPal
//
//  Created by Will Cohen on 11/24/18.
//  Copyright © 2018 Will Cohen. All rights reserved.
//

import UIKit
import SwiftyShadow
import FirebaseDatabase
import Firebase

protocol blockedUserDelegate {
    func blockedUser(_ user: String)
}

class MessagesController: UIViewController {

    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var topInformationView: UIView!
    @IBOutlet weak var chatNameLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var sendMessageViewHeightConstraint: NSLayoutConstraint!
    
    var chat: Chat!
    var messages = [Message]()
    var selectedMessage: String = ""
    var delegate: blockedUserDelegate?
    
    var newHandle: DatabaseHandle = 0
    var newRef: DatabaseReference?
    var existingHandle: DatabaseHandle = 0
    var existingRef: DatabaseReference?
    
    var newChatCalled: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            sendMessageViewHeightConstraint.constant = keyboardHeight
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                if (self.messages.count != 0) {
                    self.scrollToBottom()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tryObservingMessages(comingFromSent: false)
        //getInitialMessages()
        
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        
        messagesTableView.estimatedRowHeight = 150
        messagesTableView.rowHeight = UITableViewAutomaticDimension
        
        topInformationView.layer.cornerRadius = 10
        topInformationView.layer.shadowRadius = 5
        topInformationView.layer.shadowOpacity = 0.3
        topInformationView.layer.shadowColor = UIColor.black.cgColor
        topInformationView.layer.shadowOffset = CGSize.zero
        topInformationView.generateOuterShadow()
        
        chatNameLabel.text = MainFunctions.removeUserFromChatName(chatTitle: self.chat.title)
        
        guard let chatKey = chat?.key else { return }
        let messageDBReference = Database.database().reference().child("messages").child(chatKey)
        existingRef = messageDBReference
        existingHandle = messageDBReference.observe(.value, with: { (snapshot) in
            self.messages.removeAll()
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for (snap) in snapshot {
                    let message = Message(snapshot: snap)
                    self.messages.append(message!)
                }
                self.messagesTableView.reloadData()
                if (self.messages.count != 0) {
                    self.scrollToBottom()
                }
            }
        })
        
    }
    
    deinit {
        existingRef?.removeObserver(withHandle: existingHandle)
        newRef?.removeObserver(withHandle: newHandle)
    }
    
    private func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
            self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    @IBAction func sendMessageButton(_ sender: Any) {
        let message = messageTextView.text
        
        if chat?.key == nil {
            
            ChatService.create(from: Message(content: message!), with: chat, completion: { [weak self] chat in
                guard let chat = chat else { return }
                self?.chat = chat
                self!.messages.append(Message(content: message!))
                self!.messagesTableView.reloadData()
                
                guard let chatKey = chat.key else { return }
                let messageDBReference = Database.database().reference().child("messages").child(chatKey)
                self?.newRef = messageDBReference
                self?.newHandle = messageDBReference.observe(.value, with: { (snapshot) in
                    self?.messages.removeAll()
                    if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                        for (snap) in snapshot {
                            let message = Message(snapshot: snap)
                            self!.messages.append(message!)
                        }
                        self!.messagesTableView.reloadData()
                        if (self!.messages.count != 0) {
                            self!.scrollToBottom()
                        }
                    }
                })
            
            })
        } else {
            ChatService.sendMessage(Message(content: message!), for: chat)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func moreInformationButtonPressed(_ sender: Any) {
        
    }
    
}

extension MessagesController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if (message.sender.uid != User.sharedInstance.uid) {
            if let cell = messagesTableView.dequeueReusableCell(withIdentifier: "incomingMessage") as? IncomingMessageCell {
                cell.messageLabel.text = message.content
                return cell
            } else {
                return IncomingMessageCell()
            }
        } else {
            if let cell = messagesTableView.dequeueReusableCell(withIdentifier: "outgoingMessage") as? OutgoingMessageCell {
                cell.messageLabel.text = message.content
                return cell
            } else {
                return OutgoingMessageCell()
            }
        }
        
    }
    
}

extension MessagesController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text)
        //let sizeToFitIn = CGSize(width: messageTextView.bounds.size.width, height: CGFloat(MAXFLOAT))
        //let newSize = messageTextView.sizeThatFits(sizeToFitIn)
        //messageTextViewHeight.constant = newSize.height
    }
    
}
