//
//  FirebaseChatService.swift
//  MonsterChat
//
//  Created by Obaro Paul on 15/06/2024.
//

import Foundation
import FirebaseFirestore
import Combine



class FirebaseChatReference{
    static var instance = FirebaseChatReference()
    
    init(){}
    
     func firebaseRefrence(_ collectionRefrence:FireBaseRefEnum) -> CollectionReference{
        return Firestore.firestore().collection(collectionRefrence.rawValue)
    }
    
    
    
    
    
    
    func addChat(_ chat:Chat){
        do{
            try  firebaseRefrence(.Recent).document(chat.id).setData(from: chat)
        }catch{
            print("Error saving chat", error.localizedDescription)
        }
    }
    
 
    func getChats() -> AnyPublisher<[Chat], Error> {
        
        let subject = PassthroughSubject<[Chat], Error>()
        
        // Create a Firestore listener
        
        
        let listener = firebaseRefrence(.Recent)
            .whereField(mSenderId, isEqualTo: User.currentUserId!)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    subject.send(completion: .failure(error))
                    return
                }
                
                guard let snapshot = snapshot else {
                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No snapshot found"])
                    subject.send(completion: .failure(error))
                    return
                }
                
                do {
                    let chats = try snapshot.documents.compactMap { document in
                        try document.data(as: Chat.self)
                    }
                    subject.send(chats)
                  
                } catch {
                    subject.send(completion: .failure(error))
                }
            }
        
        // Return a publisher that will be connected to the subject
        return subject
            .handleEvents(receiveCancel: {
                // Remove the listener when the subscription is cancelled
                listener.remove()
            })
            .eraseToAnyPublisher()
    }
    
    
    

    func deleteChat(chat: Chat) -> AnyPublisher<Bool, Error> {
        Future<Bool, Error> { promise in
            self.firebaseRefrence(.Recent).document(chat.id).delete { error in
                if let error = error {
                    promise(.failure(error))
                }else{
                    promise(.success(true))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

    
