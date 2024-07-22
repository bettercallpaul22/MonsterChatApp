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

enum UpdateRecentType:String{
    case lastMessage
    case clearUnreadCounter
}


class MessageViewModel:ObservableObject{
    @Published var lastMessage:String = ""
    @Published var lastMessageObj:RealmLocalMessage? = nil
    @Published var avatar:UIImage? = nil
    @Published var realmMessages:[RealmLocalMessage] = []
    @Published var isUserTyping:Bool = false
    @Published var userMessageViewState:String = ""

    
    @Published var isLoading:Bool = false
    @Published var isSuccess:Bool = false

    
    
    private var realm:Realm
    @ObservedResults(RealmLocalMessage.self) var LocalRealArr
    var notificationToken:NotificationToken?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(){
      
        self.realm =  try! Realm()
        observeTodos()
//        resetValues()
    }
    
    func resetValues(){
        isLoading = false
        isSuccess = false
    }
    
    func getImage(_ fileName:String, directory:FireBaseImageUrlPath){
        isLoading = true
        LocalFileManager.instance.readAnWriteImage(fileName: fileName, firebaseImageUrlPath: directory.self)
            .sink { (completion) in
                switch completion{
                case .failure(let error):
                    self.isLoading = false

                    print("get image error:",error.localizedDescription)
                case .finished:
                    self.isLoading = false

                    break
                }
            } receiveValue: { image in
                self.isLoading = false

                self.avatar = image
            }.store(in: &self.cancellables)
    }
    
 
    func updateMessageReadStatus(message:RealmLocalMessage, membersId:[String]){
        if message.senderId != User.currentUserId{
            FirebaseMessageReference.instance.updateMessagesReadStatus( membersId: membersId, message: message)

        }
    }
    
    
    func typingListener(_ chatroomId:String){
        FirebaseTypingListener.instance.createTypingListener(chatroomId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion{
                    
                case .finished:
                    break
                case .failure(let error):
                    print("typing listener error :", error.localizedDescription)
                }
            } receiveValue: { value in
                self.isUserTyping = value
            }.store(in: &cancellables)
        
    }
    
    func updateTyping(typing:Bool, chatroomId:String){
        FirebaseTypingListener.instance.updateTypingState(typing: typing, chatroomId: chatroomId)
    }
    
    
    func updateMessageViewState(state:String, chatRoomId:String){
        FirebaseMessageReference.instance.updateMessageViewState(isOnViewState: state, chatroomId: chatRoomId)
    }
    
    func messageViewListener(_ chatRoomId:String){
        FirebaseMessageReference.instance.messageViewListener(chatRoomId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion{
                 case .finished:
                    print("finished")
                   break
                case .failure(let error):
                    print("error listening to user messageview state", error)
                }
            } receiveValue: {val in
                print("the update value in messageViewModel", val)
                self.userMessageViewState = val
            }.store(in: &cancellables)

    }
    
    
   
    
    func getAndUpdateRecentChat(chatRoomId:String, lastMessage:String?, updateTpye:UpdateRecentType){
    
        FirebaseChatReference.instance.firebaseRefrence(.Recent).whereField(mChatRoomId, isEqualTo: chatRoomId).getDocuments { snapshotQuery, error in
            guard let documents =  snapshotQuery?.documents else{
                print("no documents in collection")
                return
            }
            
            let allRecentChatDocuments = documents.compactMap { (doc) -> Chat? in
               return try? doc.data(as: Chat.self)
            }
            switch updateTpye {
            case .lastMessage:
                print("setupRecentWithLastMessage")

                for recentChat in allRecentChatDocuments{
                    self.setupRecentWithLastMessage(recent: recentChat, lastmessage: lastMessage ?? "")
                }
            case .clearUnreadCounter:
                print("clearUnreadCounter")
                for recentChat in allRecentChatDocuments{
                    self.clearUnreadCounter(recent: recentChat)
                }
            }
            
            
        }

       
    }
    
   private func setupRecentWithLastMessage(recent:Chat, lastmessage:String){
        var recentChat = recent
        recentChat.date = Date()
        recentChat.lastMessage = lastmessage
        if recentChat.senderId != User.currentUserId{
            recentChat.unreadCounter += 1
        }
        
        FirebaseChatReference.instance.updateRecent(recentChat: recentChat, recentId: recent.id)
    }
    
    private func clearUnreadCounter(recent:Chat){
         var recentChat = recent
         recentChat.date = Date()
         if recentChat.senderId == User.currentUserId{
             recentChat.unreadCounter = 0
         }
         
         FirebaseChatReference.instance.updateRecent(recentChat: recentChat, recentId: recent.id)
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
                sendPictureMessage(message: message, photo: photo, caption: photoCaption, membersId: membersId, messageType: .photo)
            }
        case .video:
            print("audio")
            
        case .location:
            print("audio")
            
        }

    }
    
    
    
    
    
    
    
    
    
    func getMessages(chatRoomId: String){
        print("messageView chat room id", chatRoomId)
        FirebaseMessageReference.instance.messageListener(userDocumentId: User.currentUserId!, chatRoomDocumentId: chatRoomId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion{
                case.failure(let error):
                    print("error getting old messages from firebase: \(error.localizedDescription)")
                case .finished:
                    print("a new write")                }
            } receiveValue: {  newMessage in
                print("particular chatroom messages", newMessage)
                RealmManager.instance.saveToRealm(newMessage)
              
            }.store(in: &cancellables)
    }
    
    private func observeTodos() {
        // Get all RealmLocalMessage objects from the Realm database
        let realMessages = realm.objects(RealmLocalMessage.self)
        
        // Observe changes to the collection of RealmLocalMessage objects
        notificationToken = realMessages.observe { [weak self] changes in
            guard let self = self else { return }
            
            switch changes {
            case .initial(let realmLocalMsgs):
                // Sorting messages by date in ascending order
                let sortedMessages = realmLocalMsgs.sorted(byKeyPath: "date", ascending: true)
                
                isLoading = false
                
                // Using this in the message view to trigger scroll to bottom when lastMessageObj changes
                self.lastMessageObj = sortedMessages.last
                self.realmMessages = Array(sortedMessages)
                
            case .update(let realmLocalMsgs, _, _, _):
                // Sorting messages by date in ascending order
                let sortedMessages = realmLocalMsgs.sorted(byKeyPath: "date", ascending: true)
                
                isLoading = false
                self.lastMessageObj = sortedMessages.last
                self.realmMessages = Array(sortedMessages)
                
            case .error(let error):
                isLoading = false
                print("Error observing todos: \(error.localizedDescription)")
            }
        }
    }

    
    
    
    
    
    func sendTextMessage(message:RealmLocalMessage, text:String, membersId:[String], messageType:MessageType){
        isLoading = true
        message.message = text
        message.type = MessageType.text.rawValue
        membersId.forEach { member in
            
            FirebaseMessageReference.instance.addMessage(message: message, memberId: member)
                .sink { completion in
                    switch completion{
                    case .finished:
                        self.isLoading = false
                        break
                    case .failure(let error):
                        self.isLoading = false
                        print(error.localizedDescription)
                    }
                } receiveValue: {  success in
                    self.isLoading = false
                    self.isSuccess = true
//                    print("is succes sending text message", self.isSuccess)
           
                    guard let lstMsg = self.lastMessageObj else {return}
                    self.getAndUpdateRecentChat(chatRoomId: lstMsg.chatRoomId, lastMessage: lstMsg.message, updateTpye: .lastMessage)
                }.store(in: &cancellables)
            
        }
    }
    
    func sendPictureMessage(message: RealmLocalMessage, photo: UIImage, caption: String, membersId: [String], messageType: MessageType) {
        
        let imageName = "\(message.messageId)_\(message.senderId)"
        
        // Begin a write transaction for modifying the message object
        do {
            let realm = try Realm()
            try realm.write {
                // Modifying the message object within a write transaction
                message.message = ""
                message.photoCaption = caption
                message.type = MessageType.photo.rawValue
            }
            // Save the message to Realm within the write transaction
            RealmManager.instance.saveToRealm(message)
        } catch {
            print("Error saving message to Realm: \(error.localizedDescription)")
            return
        }
        
        // Saving the image locally
        LocalFileManager.instance.saveImageLocally(image: photo, fileName: imageName)
        
        FirebaseHelper.instance.uploadImage(image: photo, directory: .photoMessage, fileName: imageName)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { pictureMessageUrl in
                membersId.forEach { memberId in
                    do {
                        let realm = try Realm()
                        try realm.write {
                            // Modifying the message object to update the picture URL within a write transaction
                            message.pictureUrl = pictureMessageUrl
                        }
                    } catch {
                        print("Error updating message picture URL in Realm: \(error.localizedDescription)")
                        return
                    }
                    
                    // Send the message to Firebase
                    FirebaseMessageReference.instance.addMessage(message: message, memberId: memberId)
                        .sink { completion in
                            switch completion {
                            case .finished:
                                break
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        } receiveValue: { success in
             
                        }.store(in: &self.cancellables)
                }
                
            }.store(in: &cancellables)
    }
    
    
    
    
    
}


