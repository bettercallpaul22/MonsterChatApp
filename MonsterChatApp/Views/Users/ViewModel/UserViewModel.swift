//
//  UserViewModel.swift
//  MonsterChat
//
//  Created by Obaro Paul on 11/06/2024.
//

import Foundation
import SwiftUI
import Combine

class UserViewModel: ObservableObject {
    static var instance = UserViewModel()
    @Published  var username = ""
    @Published  var userStatus = ""
    @Published  var userAvatar: UIImage? = nil
    @Published  var isLoading:Bool = false
    @Published var users: [User] = [] // Published array of users to update the view when it changes
    
    private var firebaseUserReference:FirebaseUserReference = FirebaseUserReference()
    private var cancellables = Set<AnyCancellable>() // Set to store Combine subscriptions
    
    
    
    init() {
        //        fetchUsers()
    }
    
    func configureUser(user: User) {
        self.username = user.username
        self.userStatus = user.status
        setAvatar(avatarLink: user.avatarLink, user: user)
    }
    
    private func setAvatar(avatarLink: String, user: User) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
            
            if !user.id.isEmpty || !user.avatarLink.isEmpty{
                FirebaseUserReference.instance.checkAndWriteNSDataToFile(filename: user.id, avatarUrl: user.avatarLink) { image in
                    if image != nil{
                        self.userAvatar = image
                    }else{
                        self.userAvatar = UIImage(named: "userimage")
                    }

                }
      
            }else{
                self.userAvatar = UIImage(named: "userimage")                    }
        }
        
    }
    

    func fetchUsers() {
        self.isLoading = true
        // Fetch users using the FirestoreService
        firebaseUserReference.fetchUsers()
            .receive(on: DispatchQueue.main) // Ensure updates are received on the main thread
            .sink(receiveCompletion: { completion in // Handle the completion event
                switch completion {
                case .failure(let error):
                    self.isLoading = false
                    
                    // If there is an error, print it (could handle it differently)
                    print("Error fetching users: \(error)")
                case .finished:
                    self.isLoading = false
                    
                    break
                }
            }, receiveValue: { [weak self] users in // Handle the received value (the array of users)
                self?.users = users
                self?.isLoading = false
                
            })
            .store(in: &cancellables) // Store the subscription to manage its lifecycle
        
        
    }
    
}

