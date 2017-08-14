//
//  ChatCell.swift
//  PenPal
//
//  Created by Will Cohen on 8/7/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var usersNameLabel: UILabel!
    @IBOutlet weak var chatsLastMessageLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var chat: Chat!
    
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
