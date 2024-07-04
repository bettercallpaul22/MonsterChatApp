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
    
    private init() {}
    
    func firebaseReference(_ collectionReference: FireBaseRefEnum) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    func addMessage(message: RealmLocalMessage, memberId: String) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            do {
                try self.firebaseReference(.Messages)
                    .document(memberId)
                    .collection(message.chatRoomId)
                    .document(message.messageId)
                    .setData(from: message) { error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.success(true))
                        }
                    }
            } catch {
                print("FirebaseMessageReference message saved failed", error.localizedDescription)
                
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    
    // Messages/document/collection/documents
    //Message/SjVfsykrQzbtNUrGaX4MTAZEJdw2/SjVfsykrQzbtNUrGaX4MTAZEJdw2/SjVfsykrQzbtNUrGaX4MTAZEJdw2dlV1nIXmSibYEKhMVlz3TOQD5eN2
    //    func getMessages(userDocumentId:String, chatRoomDocumentId:String ) -> AnyPublisher<LocalMessage?, Error> {
    //         Future<LocalMessage?, Error>{ [self] promise in
    //            firebaseReference(.Messages).document(userDocumentId).collection(chatRoomDocumentId).getDocuments { snapshot, error in
    //                if let error = error {
    //                    promise(.failure(error))
    //                    print("error getting chats documents", error.localizedDescription)
    //                }else{
    //                    guard let documents = snapshot?.documents else{
    //                        print("no documents in our collection")
    //                        return
    //                    }
    //
    //                    var oldMessages = documents.compactMap { (queryDocumentsSnapshot) -> LocalMessage? in
    //                        let messages = try? queryDocumentsSnapshot.data(as: LocalMessage.self)
    //                        promise(.success(messages))
    //                        return nil
    //                    }
    //
    //
    //                }
    //            }
    //        }.eraseToAnyPublisher()
    //
    //    }
    
  
    func messageListener(userDocumentId: String, chatRoomDocumentId: String) -> AnyPublisher<RealmLocalMessage, Error> {
        let subject = PassthroughSubject<RealmLocalMessage, Error>()
        let listener = self.firebaseReference(.Messages)
            .document(userDocumentId)
            .collection(chatRoomDocumentId)
//            .whereField(mDATE, isGreaterThan: lastMessageDate)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    subject.send(completion: .failure(error))
                    return
                }
                guard let document = snapshot else {
                    subject.send(completion: .failure(NSError(domain: "NoDocuments", code: 0, userInfo: nil)))
                    return
                }
                for change in document.documentChanges {
                    if change.type == .added {
                        do {
                            let documentData = try change.document.data(as: RealmLocalMessage.self)
                            subject.send(documentData)
                        } catch {
                            subject.send(completion: .failure(error))
                        }
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



