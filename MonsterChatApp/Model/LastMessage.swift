//
//  LastMessage.swift
//  MonsterChat
//
//  Created by Obaro Paul on 23/06/2024.
//

import Foundation

struct LastMessage:Codable{
    var date:Date
    var lastMessage:String

    
    static func setLastMessageObject(value: LastMessage, key: String) {
         let encoder = JSONEncoder()
         if let encodedMessage = try? encoder.encode(value) {
             UserDefaults.standard.set(encodedMessage, forKey: key)
         } else {
             print("Failed to encode message")
         }
     }
    
    static func getLastMessageObject(_ key: String) -> LastMessage? {
        if let savedMessageData = UserDefaults.standard.data(forKey: key) {
            if let message = try? JSONDecoder().decode(LastMessage.self, from: savedMessageData) {
                print("last message get result1", message)

                return message
            }
        }
        print("last message get result")
        return nil
    }
}
