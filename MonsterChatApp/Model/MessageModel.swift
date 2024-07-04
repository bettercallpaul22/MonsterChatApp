//
//  LocalMessageModel.swift
//  MonsterChat
//
//  Created by Obaro Paul on 28/06/2024.
//

import Foundation
import RealmSwift

class MessageModel:Object,ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var id:ObjectId
    @Persisted var chatRoomId = ""
    @Persisted var sendDate:Date = Date()
    @Persisted var messageId = ""
    @Persisted var senderId = ""
    @Persisted var senderInitials = ""
    @Persisted var incoming:Bool
    @Persisted var messagekind = ""
    @Persisted var message = ""
    @Persisted var messageStatus = ""
    @Persisted var displayName = ""
    @Persisted var readDate:Date
    
    
    convenience init(
        chatRoomId:String,
        messageId:String,
        senderId:String,
        senderInitials:String,
        incoming:Bool,
        message:String,
        readDate:Date,
        messageStatus:String,
        displayName:String
        
    ){
        self.init()
        self.chatRoomId = chatRoomId
        self.messageId = messageId
        self.senderId = senderId
        self.senderInitials = senderInitials
        self.incoming = incoming
        self.message = message
        self.readDate = readDate
        self.messageStatus = messageStatus
        self.displayName = displayName
    }
    
    
}
