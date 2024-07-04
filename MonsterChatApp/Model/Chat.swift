//
//  Chat.swift
//  MonsterChat
//
//  Created by Obaro Paul on 15/06/2024.
//

import Foundation
import FirebaseFirestoreSwift

struct Chat: Codable, Identifiable {
    var id = ""
    var chatRoomId = ""
    var senderId = ""
    var senderName = ""
    var receiverId = ""
    var receiverName = ""
    @ServerTimestamp var date = Date()
    var memberId = [""]
    var lastMessage = ""
    var unreadCounter = 0
    var avatarLink = ""
    
    
    
    
    
}
