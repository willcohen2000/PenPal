//
//  MessageController.swift
//  PenPal
//
//  Created by Will Cohen on 8/7/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

/*

import UIKit
import JSQMessagesViewController
import FirebaseDatabase.FIRDatabase

/*protocol blockedUserDelegate {
    func blockedUser(_ user: String)
}*/

class MessageController: JSQMessagesViewController {

    var chat: Chat!
    var messages = [Message]()
    var selectedMessage: String = ""
    var delegate: blockedUserDelegate?
    
    @IBOutlet weak var topView: UIView!
    
    var outgoingBubbleImageView: JSQMessagesBubbleImage = {
        guard let bubbleImageFactory = JSQMessagesBubbleImageFactory() else {
            fatalError("Error creating bubble image factory.")
        }
        
        return bubbleImageFactory.outgoingMessagesBubbleImage(with: UIColor(red:0.01, green:0.49, blue:1.00, alpha:1.0))
    }()
    
    var incomingBubbleImageView: JSQMessagesBubbleImage = {
        guard let bubbleImageFactory = JSQMessagesBubbleImageFactory() else {
            fatalError("Error creating bubble image factory.")
        }
        
        return bubbleImageFactory.incomingMessagesBubbleImage(with: UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0))
    }()
    
    var messagesHandle: DatabaseHandle = 0
    var messagesRef: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupJSQMessagesViewController()
        tryObservingMessages()
        addViewOnTop()
        self.topContentAdditionalInset = 80
        super.collectionView.backgroundColor = Colors.standardGray
        self.collectionView.collectionViewLayout.messageBubbleLeftRightMargin = 50
    }
    
    deinit {
        messagesRef?.removeObserver(withHandle: messagesHandle)
    }
    
    func backButtonPressed(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func flagUserButtonPressed(_ sender: UITapGestureRecognizer) {
        
        let blockOrFlagUserAlert = UIAlertController(title: NSLocalizedString("Do you want to block or flag user?", comment: "Do you want to block or flag user?"), message: "", preferredStyle: UIAlertControllerStyle.alert)
        blockOrFlagUserAlert.addAction(UIAlertAction(title: NSLocalizedString("Block User", comment: "Block User"), style: .default, handler: { (UIAlertAction) in
            let defaults = UserDefaults.standard
            var blockedUsers = defaults.object(forKey: "blockedUsers") as? [String] ?? [String]()
            blockedUsers.append(MainFunctions.takeObjectOutOfStringArray(object: User.sharedInstance.uid, array: self.chat.memberUIDs)[0])
            defaults.set(blockedUsers, forKey: "blockedUsers")
            defaults.synchronize()
            if let delegate = self.delegate {
                delegate.blockedUser(MainFunctions.takeObjectOutOfStringArray(object: User.sharedInstance.uid, array: self.chat.memberUIDs)[0])
            }
        }))
        
        blockOrFlagUserAlert.addAction(UIAlertAction(title: NSLocalizedString("Flag User", comment: "Flag User"), style: .default, handler: { (UIAlertAction) in
            let flagReference = Database.database().reference().child("FlaggedUsers")
            flagReference.childByAutoId().child("UID").setValue(MainFunctions.takeObjectOutOfStringArray(object: User.sharedInstance.uid, array: self.chat.memberUIDs)[0], withCompletionBlock: { (error, ref) in
                if (error == nil) {
                    MainFunctions.createSimpleAlert(alertTitle: "Thank you for flagging this user.", alertMessage: "Please continue to flag users who have graphic images for their profile image, as well as have an inapropriate name.", controller: self)
                }
            })
        }))
        
        blockOrFlagUserAlert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil))
        self.present(blockOrFlagUserAlert, animated: true, completion: nil)
        
        
        
        
        
        
        let flagUserAlert = UIAlertController(title: NSLocalizedString("Are you sure you want to block this user?", comment: "Are you sure you want to block this user?"), message: NSLocalizedString("Please confirm that you would like to permanently block this user.", comment: "Please confirm that you would like to permanently block this user."), preferredStyle: UIAlertControllerStyle.alert)
        flagUserAlert.addAction(UIAlertAction(title: NSLocalizedString("Block User", comment: "Block User"), style: .default, handler: { (UIAlertAction) in
            let defaults = UserDefaults.standard
            var blockedUsers = defaults.object(forKey: "blockedUsers") as? [String] ?? [String]()
            blockedUsers.append(MainFunctions.takeObjectOutOfStringArray(object: User.sharedInstance.uid, array: self.chat.memberUIDs)[0])
            defaults.set(blockedUsers, forKey: "blockedUsers")
            defaults.synchronize()
            if let delegate = self.delegate {
                delegate.blockedUser(MainFunctions.takeObjectOutOfStringArray(object: User.sharedInstance.uid, array: self.chat.memberUIDs)[0])
            }
            self.dismiss(animated: true, completion: nil)
        }))
        flagUserAlert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil))
        self.present(flagUserAlert, animated: true, completion: nil)
    }
    
    func addViewOnTop() {
        let selectableView = ShadowView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 75))
        selectableView.backgroundColor = .white
        let backButton = UIButton(frame: CGRect(x: 10, y: 28, width: 15, height: 30))
        backButton.setImage(UIImage(named: "StandardBackButton"), for: .normal)
        backButton.contentMode = .scaleAspectFit
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.backButtonPressed(_:))))
        let flagButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 40, y: 42, width: 30, height: 5))
        flagButton.setImage(UIImage(named: "MoreInfoIcon"), for: .normal)
        flagButton.contentMode = .scaleAspectFit
        flagButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.flagUserButtonPressed(_:))))
        let messageNameLabel = UILabel(frame: CGRect(x: 30, y: 28, width: (UIScreen.main.bounds.width - 60), height: 30))
        messageNameLabel.text = MainFunctions.removeUserFromChatName(chatTitle: self.chat.title)
        messageNameLabel.textAlignment = .center
        messageNameLabel.font = UIFont(name: "Roboto-Thin", size: 25)
        selectableView.addSubview(messageNameLabel)
        selectableView.addSubview(backButton)
        selectableView.addSubview(flagButton)
        view.addSubview(selectableView)
    }
    
    func setupJSQMessagesViewController() {

        senderId = User.sharedInstance.uid
        senderDisplayName = User.sharedInstance.name
        title = chat.title
        inputToolbar.contentView.leftBarButtonItem = nil
        
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    }
    
    func tryObservingMessages() {
        guard let chatKey = chat?.key else { return }
        
        messagesHandle = ChatService.observeMessages(forChatKey: chatKey, completion: { [weak self] (ref, message) in
            self?.messagesRef = ref
            if let message = message {
                self?.messages.append(message)
                self?.finishReceivingMessage()
            }
        })
        
    }

}

extension MessageController {
    func sendMessage(_ message: Message) {
        if chat?.key == nil {
            ChatService.create(from: message, with: chat, completion: { [weak self] chat in
                guard let chat = chat else { return }
                self?.chat = chat
                self?.tryObservingMessages()
            })
        } else {
            ChatService.sendMessage(message, for: chat)
        }
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
   
        let message = Message(content: text)
        sendMessage(message)
        finishSendingMessage()
        
        JSQSystemSoundPlayer.jsq_playMessageSentAlert()
    }
    
    
}

extension MessageController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item].jsqMessageValue
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        let sender = message.sender
        
        if sender.uid == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let message = messages[indexPath.row]
        let sender = message.sender
        
        if (User.sharedInstance.uid != sender.uid) {
            let alert = UIAlertController(title: NSLocalizedString("Do you want to correct this message?", comment: "Do you want to correct this message?"), message:
                "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Yes!", comment: "Yes!"), style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                self.selectedMessage = message.content
                self.performSegue(withIdentifier: Constants.Segues.toCorrections, sender: nil)
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("No Thanks", comment: "No Thanks"), style: UIAlertActionStyle.destructive,handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = messages[indexPath.item]
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        cell.textView?.textColor = (message.sender.uid == senderId) ? .white : .black
        
        var isOutgoing = false
        
        if message.sender.uid == User.sharedInstance.uid {
            isOutgoing = true
        }
        
        if isOutgoing {
            cell.textView.textColor = UIColor.white
            cell.textView.linkTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
        } else {
            cell.textView.textColor = UIColor.black
            cell.textView.linkTextAttributes = [NSForegroundColorAttributeName : UIColor.black, NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
        }
        
        return cell
    }
    
}

extension MessageController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.Segues.toCorrections) {
            if let makeNewCorrectionController = segue.destination as? MakeNewCorrectionController {
                makeNewCorrectionController.message = self.selectedMessage
                makeNewCorrectionController.members = MainFunctions.takeObjectOutOfStringArray(object: User.sharedInstance.uid, array: self.chat.memberUIDs)
            }
        }
    }
}


*/
