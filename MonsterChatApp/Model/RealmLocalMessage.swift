//
//  LocalMessageModel.swift
//  MonsterChat
//
//  Created by Obaro Paul on 28/06/2024.
//

import Foundation
import RealmSwift

class RealmLocalMessage:Object,ObjectKeyIdentifiable, Codable{
    @Persisted(primaryKey: true) var id:ObjectId
    
    @Persisted var messageId = ""
    @Persisted var messageType = ""
    @Persisted var chatRoomId = ""
    @Persisted var date = Date()
    @Persisted var senderName = ""
    @Persisted var senderId = ""
    @Persisted var senderInitials = ""
    @Persisted var readDate = Date()
    @Persisted var type = ""
    @Persisted var status = ""
    @Persisted var message = ""
    @Persisted var audioUrl = ""
    @Persisted var videoUrl = ""
    @Persisted var pictureUrl = ""
    @Persisted var photoCaption = ""
    @Persisted var latitude = 0.0
    @Persisted var logtitude = 0.0
    @Persisted var audioDuration = 0.0
    
    enum CodingKeys: String, CodingKey {
        case id
        case messageId
        case messageType
        case chatRoomId
        case date
        case senderName
        case senderId
        case senderInitials
        case readDate
        case type
        case status
        case message
        case audioUrl
        case videoUrl
        case pictureUrl
        case photoCaption
        case latitude
        case logtitude
        case audioDuration
    }
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(messageId, forKey: .messageId)
        try container.encode(messageType, forKey: .messageType)
        try container.encode(chatRoomId, forKey: .chatRoomId)
        try container.encode(date, forKey: .date)
        try container.encode(senderName, forKey: .senderName)
        try container.encode(senderId, forKey: .senderId)
        try container.encode(senderInitials, forKey: .senderInitials)
        try container.encode(readDate, forKey: .readDate)
        try container.encode(type, forKey: .type)
        try container.encode(status, forKey: .status)
        try container.encode(message, forKey: .message)
        try container.encode(audioUrl, forKey: .audioUrl)
        try container.encode(videoUrl, forKey: .videoUrl)
        try container.encode(pictureUrl, forKey: .pictureUrl)
        try container.encode(photoCaption, forKey: .photoCaption)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(logtitude, forKey: .logtitude)
        try container.encode(audioDuration, forKey: .audioDuration)
    }
    
    
    
}
