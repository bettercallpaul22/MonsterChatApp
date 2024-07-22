//
//  FirebaseMessageReference.swift
//  MonsterChat
//
//  Created by Obaro Paul on 19/06/2024.
//

import Foundation
import FirebaseFirestore
import Combine



class FirebaseMessageReference {
    static var instance = FirebaseMessageReference()
    private var messageViewListener: ListenerRegistration?
    private init() {}
    
    func firebaseReference(_ collectionReference: FireBaseRefEnum) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    func addMessage(message: RealmLocalMessage, memberId: String) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            do {
                let db = Firestore.firestore()
                let messageData = try Firestore.Encoder().encode(message) // Encode message using Firestore's Encoder
                
                db.collection("Messages")
                    .document(memberId)
                    .collection(message.chatRoomId)
                    .document(message.messageId)
                    .setData(messageData) { error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.success(true))
                        }
                    }
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    
    
    func updateMessagesReadStatus(membersId:[String], message:RealmLocalMessage){
        membersId.forEach { memberId in
            firebaseReference(.Messages).document(memberId).collection(message.chatRoomId).getDocuments { documentSnapshot, error in
                guard let documents = documentSnapshot?.documents else{
                    return
                }
                
                documents.forEach { doc in
                    // update status in the doc ["status":"read"]
                    do {
                        let messageDoc = try doc.data(as: RealmLocalMessage.self)
                        messageDoc.status = "read" // Update the status to "read"
                        
                        // Update the document in Firestore
                        self.firebaseReference(.Messages).document(memberId).collection(message.chatRoomId).document(doc.documentID).updateData(["status":"read"]) { error in
                            if let error = error {
                                print("Error updating document: \(error)")
                            } else {
//                                print("Document successfully updated")
                            }
                        }
                    } catch {
                        print("Error getting messageDoc", error)
                    }
                }
            }

        }
        
//        firebaseReference(.Messages).document("CKOhDdXzhycP7JMi0lmsVWb2ODo2").collection(message.chatRoomId).getDocuments { documentSnapshot, error in
//            guard let documents = documentSnapshot?.documents else{
//                return
//            }
//            
//            documents.forEach { doc in
//                // update status in the doc ["status":"read"]
//                do {
//                    var messageDoc = try doc.data(as: RealmLocalMessage.self)
//                    messageDoc.status = "read" // Update the status to "read"
//                    
//                    // Update the document in Firestore
//                    self.firebaseReference(.Messages).document("CKOhDdXzhycP7JMi0lmsVWb2ODo2").collection(message.chatRoomId).document(doc.documentID).updateData(["status":"read"]) { error in
//                        if let error = error {
//                            print("Error updating document: \(error)")
//                        } else {
//                            print("Document successfully updated")
//                        }
//                    }
//                } catch {
//                    print("Error getting messageDoc", error)
//                }
//            }
//        }
        
        //          membersId.forEach { userId in
        //              let messageCollection = firebaseReference(.Messages).document(userId).collection(message.chatRoomId)
        //              messageCollection.document(message.id.stringValue).updateData(["status":"read"] as [String: Any])
        //              var count = 0
        //              print("update message", count = count + 1)
        //          }
        
    }
    
    func updatelisteneronExit(userId:String){
//        firebaseReference(.MessageViewListener).w
    }
    
    func messageViewListener(_ chatroomId: String) -> AnyPublisher<String, Error> {
        let subject = PassthroughSubject<String, Error>()
        
        _ = firebaseReference(.MessageViewListener).document(chatroomId).addSnapshotListener { document, error in
            guard let document = document else {
                return
            }
            
            if document.exists{
                // filter the dictionary document and return the other user
                //                let otherUser =  document.data()?.filter{$0.key != User.currentUserId}
                //                let otherUserState = otherUser?.first?.value as! String
                //                subject.send(otherUserState)
                for doc in document.data()!{
                    if doc.key != User.currentUserId{ // the other user
                        // send the other user online state
                        subject.send(doc.value as! String)
                    }
                }
            } else {
                print("create a new viewMessageListener")
                
                self.firebaseReference(.MessageViewListener).document(chatroomId).setData([User.currentUserId!: ""])
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    func updateMessageViewState(isOnViewState:String, chatroomId:String){
        firebaseReference(.MessageViewListener).document(chatroomId).updateData([User.currentUserId!: isOnViewState])
    }
    
    func removeMessageViewListener() {
        messageViewListener?.remove()
        messageViewListener = nil
    }
    


    func messageListener(userDocumentId: String, chatRoomDocumentId: String) -> AnyPublisher<RealmLocalMessage, Error> {
        let subject = PassthroughSubject<RealmLocalMessage, Error>()
        let listener = self.firebaseReference(.Messages)
            .document(userDocumentId)
            .collection(chatRoomDocumentId)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    subject.send(completion: .failure(error))
                    return
                }
                guard let snapshot = snapshot else {
                    subject.send(completion: .failure(NSError(domain: "NoDocuments", code: 0, userInfo: nil)))
                    return
                }
                for change in snapshot.documentChanges {
                    switch change.type {
                    case .added, .modified:
                        do {
                            let documentData = try change.document.data(as: RealmLocalMessage.self)
                            subject.send(documentData)
                        } catch {
                            subject.send(completion: .failure(error))
                        }
                    case .removed:
                        // Handle document removal if needed
                        break
                    }
                }
            }
        
        // Return a publisher that will be connected to the subject
        return subject
            .handleEvents(receiveCancel: {
                listener.remove()
            })
            .eraseToAnyPublisher()
    }

    
//    
//    func messageListener(userDocumentId: String, chatRoomDocumentId: String) -> AnyPublisher<RealmLocalMessage, Error> {
//        let subject = PassthroughSubject<RealmLocalMessage, Error>()
//        let listener = self.firebaseReference(.Messages)
//            .document(userDocumentId)
//            .collection(chatRoomDocumentId)
//            .addSnapshotListener { snapshot, error in
//                if let error = error {
//                    subject.send(completion: .failure(error))
//                    return
//                }
//                guard let document = snapshot else {
//                    subject.send(completion: .failure(NSError(domain: "NoDocuments", code: 0, userInfo: nil)))
//                    return
//                }
//                for change in document.documentChanges {
//                    if change.type == .added {
//                        do {
//                            let documentData = try change.document.data(as: RealmLocalMessage.self)
//                            subject.send(documentData)
//                        } catch {
//                            subject.send(completion: .failure(error))
//                        }
//                    }
//                }
//            }
//        
//        // Return a publisher that will be connected to the subject
//        return subject
//            .handleEvents(receiveCancel: {
//                listener.remove()
//            })
//            .eraseToAnyPublisher()
//    }
//    
    
    func getMessages(userDocumentId: String, chatRoomDocumentId: String) -> AnyPublisher<[RealmLocalMessage], Error> {
        Future<[RealmLocalMessage], Error> { promise in
            self.firebaseReference(.Messages).document(userDocumentId).collection(chatRoomDocumentId).getDocuments { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                    print("Error getting chats documents:", error.localizedDescription)
                } else {
                    guard let documents = snapshot?.documents else {
                        print("No documents in our collection")
                        promise(.success([]))  // Return an empty array if no documents are found
                        return
                    }
                    
                    let messages = documents.compactMap { queryDocumentSnapshot -> RealmLocalMessage? in
                        return try? queryDocumentSnapshot.data(as: RealmLocalMessage.self)
                    }
                    
                    promise(.success(messages))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    
    
    
}



