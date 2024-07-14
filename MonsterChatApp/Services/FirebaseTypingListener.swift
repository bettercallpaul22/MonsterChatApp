//
//  FirebaseTypingListener.swift
//  MonsterChatApp
//
//  Created by Obaro Paul on 07/07/2024.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseStorage
import Combine


class FirebaseTypingListener{
    static let instance = FirebaseTypingListener()
    private var typingListener: ListenerRegistration?
    func firebaseRefrence(_ collectionRefrence:FireBaseRefEnum) -> CollectionReference{
        return Firestore.firestore().collection(collectionRefrence.rawValue)
    }
    private init(){}
    
    
    func createTypingListener(_ chatroomId: String) -> AnyPublisher<Bool, Error> {
        let subject = PassthroughSubject<Bool, Error>()
        
        _ = firebaseRefrence(.Typing).document(chatroomId).addSnapshotListener { document, error in
            guard let document = document else {
                subject.send((error != nil))
                return
            }
            
            if document.exists{
                for data in document.data()!{
                    if data.key != User.currentUserId{
                        subject.send(data.value as! Bool)
                    }
                }
            } else {
                self.firebaseRefrence(.Typing).document(chatroomId).setData([User.currentUserId!: false])
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    
    // update user typing state
    func updateTypingState(typing:Bool, chatroomId:String){
        firebaseRefrence(.Typing).document(chatroomId).updateData([User.currentUserId!: typing])
    }
    
    func removeTypingListener() {
           typingListener?.remove()
           typingListener = nil
       }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
