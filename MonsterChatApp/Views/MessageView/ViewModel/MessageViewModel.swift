//
//  MessageViewModel.swift
//  MonsterChat
//
//  Created by Obaro Paul on 18/06/2024.
//

import Foundation
import SwiftUI
import RealmSwift
import Combine

class MessageViewModel:ObservableObject{
    @Published var messages:[Message] = []
    @Published var lastMessage:String = ""
    @Published var lastMessageObj:Message? = nil
    @Published var realmMessages:[RealmLocalMessage] = []
    
    private var realm:Realm
    @ObservedResults(RealmLocalMessage.self) var LocalRealArr
    var notificationToken:NotificationToken?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        self.realm =  try! Realm()
        observeTodos()
    }
    
    private func observeTodos() {
        let realMessages = realm.objects(RealmLocalMessage.self)
        notificationToken = realMessages.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial(let realmLocalMsgs):
                print("Initial load of realm objects \(realMessages)", realMessages)
                self.realmMessages = Array(realmLocalMsgs)
            case .update(let realmLocalMsgs, _, _, _):
                // Update the published property when changes occur
                print("A new message added to list")
                
                self.realmMessages = Array(realmLocalMsgs)
            case .error(let error):
                print("Error observing todos: \(error.localizedDescription)")
            }
        }
    }
    
    func senMessage(
        messageType:MessageType,
        text:String,
        photo:UIImage?,
        photoCaption:String,
        video:String?,
        audio:String?,
        location:String?,
        audioDuration:Float = 0.0,
        membersId:[String],
        chatRoomId:String
    ){
        let currentUser = User.currentUser!
        let message = RealmLocalMessage()
        message.messageId = UUID().uuidString
        message.chatRoomId = chatRoomId
        message.senderId = currentUser.id
        message.senderName = currentUser.username
        message.senderInitials = String(currentUser.username.first!)
        message.date = Date()
        message.status = mMessageStatusSent
        
        switch messageType{
        case .text:
            if !text.isEmpty {
                sendTextMessage(message: message, text: text, membersId: membersId, messageType: .text)
            }
        case .audio:
            print("audio")
        case .photo:
           
            if let photo = photo {
                print("message case is photo")
                sendPictureMessage(message: message, photo: photo, caption: text, membersId: membersId, messageType: .photo)
            }
        case .video:
            print("audio")
            
        case .location:
            print("audio")
      
        }
        
        
        
    }
    
    func getMessages(chatRoomId: String){
        FirebaseMessageReference.instance.messageListener(userDocumentId: User.currentUserId!, chatRoomDocumentId: chatRoomId)
            .sink { completion in
                switch completion{
                case.failure(let error):
                    print("error getting old messages from firebase: \(error.localizedDescription)")
                case .finished:
                    
                    print("a new write")                }
            } receiveValue: { newMessage in
                print("message listener", newMessage)
                RealmManager.instance.saveToRealm(newMessage)
            }.store(in: &cancellables)
    }
    
    
    
    
    
    
    func sendTextMessage(message:RealmLocalMessage, text:String, membersId:[String], messageType:MessageType){
        message.message = text
        message.type = MessageType.text.rawValue
        membersId.forEach { member in
            FirebaseMessageReference.instance.addMessage(message: message, memberId: member)
                .sink { completion in
                    switch completion{
                    case .finished:
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                } receiveValue: { success in
                    if success{
                        print("message sent success: \(success)")
                    }
                }.store(in: &cancellables)
            
        }
        print("message saved to Realm $LocalRealArr")
        
    }
    
    
    func sendPictureMessage(message:RealmLocalMessage, photo:UIImage, caption:String, membersId:[String], messageType:MessageType){
        let pictureMessageUrl = "Media/Photos" + "\(message.messageId)_\(message.senderId)" + ".jpg"
        message.photoCaption = caption
        message.type = MessageType.photo.rawValue
        
        FirebaseUserReference.instance.uploadImage(image: photo, directory: pictureMessageUrl)
            .sink { completion in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { pictureMessageUrl in
                
                membersId.forEach { memberId in
                    FirebaseMessageReference.instance.addMessage(message: message, memberId: memberId)
                        .sink { completion in
                            switch completion{
                            case .finished:
                                break
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        } receiveValue: { success in
                            if success{
                                print("message sent success: \(success)")
                            }
                        }.store(in: &self.cancellables)
                }
                message.pictureUrl = pictureMessageUrl
                print("picture message sent success", pictureMessageUrl)
            }.store(in: &cancellables)
        
    }
    
    
    
    
    
}


