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
     

  
        
}
