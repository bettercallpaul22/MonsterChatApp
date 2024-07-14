//
//  FirebaseService.swift
//  MonsterChat
//
//  Created by Obaro Paul on 12/06/2024.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseStorage
import Combine

class FirebaseUserReference {
    static var instance = FirebaseUserReference()
    private var cancellables = Set<AnyCancellable>()
    
    func firebaseRefrence(_ collectionRefrence:FireBaseRefEnum) -> CollectionReference{
        return Firestore.firestore().collection(collectionRefrence.rawValue)
    }
    
    
    // fetch all users in the Users collection
    func fetchUsers() -> AnyPublisher<[User], Error> {
        Future<[User], Error> { promise in
            
            self.firebaseRefrence(.User).getDocuments { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    let users = snapshot?.documents.compactMap { document -> User? in
                        
                        try? document.data(as: User.self)
                    } ?? []
                    let filteredUser = users.filter{$0.id != User.currentUserId  }
                    promise(.success(filteredUser))
                    //                        print("users firebase service  :\(users)")
                    
                }
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    
    // get user
    
    func getUsers(withIds userIds: [String]) -> AnyPublisher<[User], Error> {
        
        let userPublishers = userIds.map { userId in
            Future<User, Error> { promise in
                let userRef = self.firebaseRefrence(.User).document(userId)
                
                userRef.getDocument { (document, error) in
                    if let error = error {
                        promise(.failure(error))
                    } else if let document = document, document.exists {
                        do {
                            if let user = try document.data(as: User?.self) {
                                promise(.success(user))
                            } else {
                                promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode user"])))
                            }
                        } catch {
                            promise(.failure(error))
                        }
                    } else {
                        promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                    }
                }
            }.eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(userPublishers)
            .collect()
            .eraseToAnyPublisher()
    }
    
    // save a user
    func saveUser(userData: User) -> AnyPublisher<Void, Error> {
        Future { promise in
            do {
                try self.firebaseRefrence(.User).document(userData.id).setData(from: userData) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                        
                    }
                    
                }
            } catch {
                promise(.failure(error))
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    
}












