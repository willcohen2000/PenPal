//
//  ChatCell.swift
//  PenPal
//
//  Created by Will Cohen on 8/7/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit
import SwiftyShadow

class ChatCell: UITableViewCell {

    @IBOutlet weak var usersNameLabel: UILabel!
    @IBOutlet weak var chatsLastMessageLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var innerChatView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var chat: Chat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 1, alpha: 0)
        innerChatView.layer.cornerRadius = 10
        innerChatView.layer.shadowRadius = 5
        innerChatView.layer.shadowOpacity = 0.3
        innerChatView.layer.shadowColor = UIColor.black.cgColor
        innerChatView.layer.shadowOffset = CGSize.zero
        innerChatView.generateOuterShadow()
    }
    
    func configureCell(chat: Chat) {
        self.chat = chat
        self.usersNameLabel.text = MainFunctions.removeUserFromChatName(chatTitle: chat.title)
        if let lastMessageSentDate = chat.lastMessageSent {
            timeStampLabel.text = MainFunctions.convertDateToReadable(time: lastMessageSentDate)
        }
        if let lastChatMessage = chat.lastMessage {
            chatsLastMessageLabel.text = lastChatMessage
        }
    }

}
