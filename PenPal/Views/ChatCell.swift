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
    
    var chat: Chat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(chat: Chat) {
        self.chat = chat
        usersNameLabel.text = chat.title
        chatsLastMessageLabel.text = chat.lastMessage
    }

}
