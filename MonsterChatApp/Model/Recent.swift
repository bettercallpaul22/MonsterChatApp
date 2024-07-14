//
//  Recent.swift
//  MonsterChatApp
//
//  Created by Obaro Paul on 08/07/2024.
//
//id: UUID().uuidString, // Use UUID() directly to get a new UUID string
//chatRoomId: chatRoomId,
//senderId: senderUser.id,
//senderName: senderUser.username,
//receiverId: receiverUser.id,
//receiverName: receiverUser.username,
//date: Date(),
//memberId: [senderUser.id, receiverUser.id],
//lastMessage: "",
//unreadCounter: 0,
//avatarLink: receiverUser.avatarLink
import Foundation

struct Recent:Codable, Identifiable {
    var id = ""
    var chatRoomId:String
    var senderId:String
    var senderName:String
    var receiverId:String
    var date:Date
    var memberId:[String]
    var lastMessage:String
    var unreadCounter:Int
    var avatarLink:String
}
